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
    
    func getTokenBalance(contract: String, address: String) async throws -> BigUInt
    func getTokenContract(address contract: String) async throws -> ChainKit.ERC721
    func getTokenTransferEvents(for address: String) async throws -> [ERC721Transfer]
    func getTokenURI(contract: String, tokenId: BigUInt) async throws -> URL
    func ownerOf(tokenId: BigUInt, in contract: String) async throws -> String
    func totalSupply(contract: String) async throws -> BigUInt 

}
extension ERC721Client {
    
    public func getTokenURIs(contract: String, tokenIds: [BigUInt]) async -> [ (BigUInt, URL) ] {
        await withTaskGroup(of: (BigUInt, URL)?.self) { group in
            tokenIds.forEach { tokenId in
                group.addTask {
                    if let uri = try? await self.getTokenURI(contract: contract, tokenId: tokenId) {
                        return (tokenId, uri)
                    } else {
                        return nil
                    }
                }
            }
            return await group.reduce(into: [ (BigUInt, URL) ]()) { partialResult, result in
                if let result {
                    partialResult.append(result)
                }
            }
        }
    }
    
    public func fetchNFTs(in tokens: [String : [BigUInt] ] ) async -> [ChainKit.ERC721 : [ (BigUInt, URL) ] ] {
        await withTaskGroup(of: (ChainKit.ERC721?,[ (BigUInt, URL) ] ).self) { group in
            for (contract, tokenIds) in tokens {
                group.addTask {
                    async let URIs = await self.getTokenURIs(contract: contract, tokenIds: tokenIds)
                    async let contract = try? await self.getTokenContract(address: contract)
                    
                    return await (contract, URIs)
                }
            }
            
            return await group.reduce(into: [ ChainKit.ERC721 : [ (BigUInt, URL) ] ]()) { partialResult, result in
                if let contract = result.0 {
                    partialResult[contract] = result.1
                }
            }
        }
    }
    
    public func fetchNFTs(transfers: [any ERC721TransferProtocol], owner address: String) async -> [ChainKit.ERC721 : [ (BigUInt, URL) ] ] {
        let interactions = self.filter(transfers: transfers, for: address)
        return await fetchNFTs(in: interactions)

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
