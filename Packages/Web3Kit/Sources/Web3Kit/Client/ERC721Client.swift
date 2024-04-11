//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt
import web3
import ChainKit

public protocol ERC721Client {
    
    func getTokenBalance(contract: EthereumAddress, address: EthereumAddress) async throws -> BigUInt
    func getTokenContract(address contract: EthereumAddress) async throws -> ERC721
    func getTokenTransferEvents(for address: EthereumAddress) async throws -> [ERC721Transfer]
    func getTokenURI(contract: EthereumAddress, tokenId: BigUInt) async throws -> URL
    func ownerOf(tokenId: BigUInt, in contract: EthereumAddress) async throws -> String
    func totalSupply(contract: EthereumAddress) async throws -> BigUInt

}

public struct NFT: ChainKit.ERC721Protocol, Codable, Hashable {
    public let tokenId: BigUInt
    public let uri: URL
}


extension ERC721Client {
    
    public func fetchNFTS(for address: EthereumAddress) async throws -> [ERC721 : [NFT] ] {
        guard let transfers = try? await self.getTokenTransferEvents(for: address) else {return [:]}
        let filtered = self.filter(transfers: transfers, for: address)
        let nfts = await self.getNFTs(in: filtered)
        return nfts
    }
    
    public func getTokenURIs(contract: EthereumAddress, tokenIds: [BigUInt]) async -> [ NFT ] {
        await withTaskGroup(of: NFT?.self) { group in
            tokenIds.forEach { tokenId in
                group.addTask {
                    if let uri = try? await self.getTokenURI(contract: contract, tokenId: tokenId) {
                        return NFT(tokenId: tokenId, uri: uri)
                    } else {
                        return nil
                    }
                }
            }
            return await group.reduce(into: [ NFT ]()) { partialResult, result in
                if let result {
                    partialResult.append(result)
                }
            }
        }
    }
    
    public func getNFTs(in tokens: [EthereumAddress : [BigUInt] ] ) async -> [ERC721 : [ NFT ] ] {
        await withTaskGroup(of: (ERC721?,[ NFT ] ).self) { group in
            for (contract, tokenIds) in tokens {
                group.addTask {
                    async let URIs = await self.getTokenURIs(contract: contract, tokenIds: tokenIds)
                    async let contract = try? await self.getTokenContract(address: contract)
                    
                    return await (contract, URIs)
                }
            }
            
            return await group.reduce(into: [ ERC721 : [ NFT ] ]()) { partialResult, result in
                if let contract = result.0 {
                    partialResult[contract] = result.1
                }
            }
        }
    }
    
    public func getNFTs(transfers: [any ERC721TransferProtocol], owner address: EthereumAddress) async -> [ERC721 : [ NFT ] ] {
        let interactions = self.filter(transfers: transfers, for: address)
        return await getNFTs(in: interactions)

    }
}

extension ERC721Client {
    public func filter(transfers: [any ERC721TransferProtocol], for address: EthereumAddress) -> [EthereumAddress: [BigUInt]] {
        var currentHeldNFTs: [EthereumAddress: [BigUInt]] = [:]
        var ownershipChanges: [String: String] = [:] // Tracks the most recent owner of each NFT.

        for transfer in transfers {
            let contract = transfer.contract.string.lowercased()
            let tokenId = transfer.tokenId
            let transferKey = "\(contract)_\(tokenId)"
            // Update the latest known owner of the NFT.
            ownershipChanges[transferKey] = transfer.to.string.lowercased()
        }
        
        // After processing all transfers, determine which NFTs are currently held by the address.
        for (key, currentOwner) in ownershipChanges {
            let components = key.components(separatedBy: "_")
            guard components.count == 2, let contractString = components.first, let tokenIdString = components.last, let tokenId = BigUInt(tokenIdString) else {
                continue
            }

            let contract = EthereumAddress(contractString)
            if currentOwner == address.string.lowercased() {
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

//
//public protocol ERC721TokenProtocol: NFTProtocol {
//    var contract: EthereumAddress {get}
//    var tokenId: BigUInt {get}
//    var uri: URL? {get}
//}
//extension ERC721TokenProtocol {
//    public var id: String { contract.string + "_" + tokenId.description }
//}
//
//public struct ERC721Token<C:Contract>: ERC721TokenProtocol {
//    public let token: C
//    public let contract: EthereumAddress
//    public let tokenId: BigUInt
//    public let uri: URL?
//}
//public typealias NFT = ERC721Token
//public extension ERC721 {
//    typealias Token = ERC721Token
//}
