//
//  NFTFetcher.swift
//  CocciWallet
//
//  Created by Michael on 4/13/24.
//

import SwiftUI
import Web3Kit


//extension Web3Kit.EthereumClient {
//    public func fetchNFTS(for address: EthereumAddress) async throws -> [ERC721 : [NFT] ] {
//        let transfers = try await node.getTokenTransferEvents(for: address)
//        let filtered = node.filter(transfers: transfers, for: address)
//        let nfts = try await node.fetchNFTS(for: address)
//        
//        return await withTaskGroup(of: (ERC721, NFT ).self) { group in
//            nfts.forEach{ contract, tokens in
//                tokens.forEach { token in
//                    group.addTask {
//                        let nft = NFT(nft: token, contract: contract)
////                        await nft.fetch()
//                        return (contract, nft)
//                    }
//                }
//
//            }
//            return await group.reduce(into: [ERC721 : [NFT] ]()) { partialResult, result in
//                let (contract, nft) = result
//                partialResult[contract, default: []].append(nft)
//            }
//        }
//    }
//    
//}
