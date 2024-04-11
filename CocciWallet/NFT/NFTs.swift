////
////  NFTs.swift
////  CocciWallet
////
////  Created by Michael on 4/8/24.
////
//
//import Foundation
//import Web3Kit
//
//@Observable
//class NFTs: Codable {
//    
//    var tokens: [ERC721: [NFTMetadata]] = [:]
//    
//    func fetch<Client:ERC721Client>(address: EthereumAddress, with client: Client) async {
//        
//        guard let transfers = try? await client.getTokenTransferEvents(for: address) else {return}
//        let filtered = client.filter(transfers: transfers, for: address)
//        let nfts = await client.getNFTs(in: filtered)
//        
////        self.tokens = await withTaskGroup(of: (ERC721, NFTMetadata).self, returning: [ERC721: [NFTMetadata]].self) { group in
////            for (contract, tokenIds) in nfts {
////                for (tokenId, uri) in tokenIds {
////                    group.addTask {
////                        let nft = NFTMetadata(contract: contract, tokenId: tokenId, uri: uri, json: nil)
////                        await nft.fetch()
////                        return (contract, nft)
////                    }
////                }
////            }
////            
////            return await group.reduce(into: [ERC721: [NFTMetadata]]()) { partialResult, result in
////                partialResult[result.0, default: []].append(result.1)
////            }
////        }
//    }
//}
//extension NFTs {
//    enum CodingKeys: String, CodingKey {
//        case _tokens = "tokens"
//    }
//}
