//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt
import web3

public protocol ERC721Client {
    func getERC721Balance(contract: String, address: String) async throws -> BigUInt
    func getERC721Contract(for contract: String) async throws -> ERC721
    func getERC721TransferEvents(for address: String) async throws -> [ERC721Transfer]
    func getERC721URI(contract: String, tokenId: BigUInt) async throws -> URL
    
//    func getERC721Metadata(contract: String, tokenId: BigUInt) async throws -> Data

}

extension ERC721Client {
    
    public func getToken(erc721: ERC721, tokenId: BigUInt) async throws -> ERC721.Token {
        let uri = try? await getERC721URI(contract: erc721.contract, tokenId: tokenId)
        var metadata: Data?
        if let uri {
            do {
                let gateway = IPFS.gateway(uri: uri)
                let (data, _) = try await URLSession.shared.data(from: gateway)
                metadata = data
            } catch {}
        }
        return .init(token: erc721, tokenId: tokenId, uri: uri, metadata: metadata)
    }
    
    public func getERC721Tokens(contract: String, tokenIds: [BigUInt]) async throws -> [ERC721.Token] {
        let contract = try await self.getERC721Contract(for: contract)
        return try await self.getERC721Tokens(erc721: contract, tokenIds: tokenIds)
    }
    
    public func getERC721Tokens(erc721: ERC721, tokenIds: [BigUInt]) async throws -> [ERC721.Token] {
        try await withThrowingTaskGroup(of: ERC721.Token?.self, returning: [ERC721.Token].self) { group in
            tokenIds.forEach { tokenId in
                group.addTask {
                    return try? await self.getToken(erc721: erc721, tokenId: tokenId)
                }
            }
            return try await group.reduce(into: [ERC721.Token]()) { partialResult, token in
                if let token {
                    partialResult.append(token)
                }
            }
        }
    }
    
    public func fetchNFTs(in tokens: [String : [BigUInt] ] ) async throws -> [ERC721 : [ERC721.Token] ] {
        try await withThrowingTaskGroup(of: [ERC721.Token].self) { group in
            for (contract, tokenIds) in tokens {
                group.addTask {
                    try await getERC721Tokens(contract: contract, tokenIds: tokenIds)
                }
            }
            
            let nfts = try await group.reduce(into: [ERC721.Token]()) { partialResult, token in
                partialResult.append(contentsOf: token)
            }
            return Dictionary(grouping: nfts, by: { $0.token })
        }
    }
}

extension ERC721Client {
    public func filter(transfers: [any ERC721TransferProtocol], for address: String) -> [String: [BigUInt]] {
        var currentHeldNFTs: [String: [BigUInt]] = [:]
        var ownershipChanges: [String: String] = [:] // Tracks the most recent owner of each NFT.

        for transfer in transfers {
            let contract = transfer.contract.lowercased()
            let tokenId = transfer.tokenId
            let transferKey = "\(contract)_\(tokenId)"
            // Update the latest known owner of the NFT.
            ownershipChanges[transferKey] = transfer.toAddress.lowercased()
        }
        
        // After processing all transfers, determine which NFTs are currently held by the address.
        for (key, currentOwner) in ownershipChanges {
            let components = key.components(separatedBy: "_")
            guard components.count == 2, let contract = components.first, let tokenIdString = components.last, let tokenId = BigUInt(tokenIdString) else {
                continue
            }

            if currentOwner == address.lowercased() {
                // If the address is the current owner, add the NFT to the currentHeldNFTs.
                if currentHeldNFTs[contract] != nil {
                    currentHeldNFTs[contract]?.append(tokenId)
                } else {
                    currentHeldNFTs[contract] = [tokenId]
                }
            } else {
            }
        }

        return currentHeldNFTs
    }
}


public protocol ERC721TransferProtocol: ERCTransfer {
    var tokenId: BigUInt {get}
}

public typealias ERC721Transfer = ERC721Events.Transfer

extension ERC721Events.Transfer: ERC721TransferProtocol {
    public var sorter: String { self.log.blockNumber.stringValue }
    public var id: String {
        self.log.transactionHash ?? "\(toAddress)_\(fromAddress)_\(tokenId.description)_\(log.data)"
    }
    public var toAddress: String {
        self.to.asString()
    }
    
    public var fromAddress: String {
        self.from.asString()
    }
    
    public var bigValue: BigUInt? {
        nil
    }
    
    public var contract: String {
        self.log.address.asString()
    }
    
    public var title: String {
        "NFT Transfer"
    }
    
    public var subtitle: String {
        self.contract
    }
    
    
}
