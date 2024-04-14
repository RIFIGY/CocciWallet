//
//  NFTs+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/29/24.
//

import Foundation
import Web3Kit
import BigInt
import ChainKit


extension URL {
    static let munko2309 = URL(string: "ipfs://bafybeihbys33ageiel4lcfvfbppwnsayzwtesz4hcuq7iv4hhcjqc2lhte/2309")!
    static let munko2310 = URL(string: "ipfs://bafybeihbys33ageiel4lcfvfbppwnsayzwtesz4hcuq7iv4hhcjqc2lhte/2310")!
    
    static let image2309 = URL(string: "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/e703713595264f15bb3363380a1fe55bee7798a85705495aa607d4b3c420b8ae.jpg")!
    static let image2310 = URL(string: "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/d9c8d4b7886844779f25fb44fc721117eb0d290415c54a03926e3f0d0f3e1590.jpg")!

}

extension Web3Kit.NFT {
    static let munko2309 = Web3Kit.NFT(tokenId: 2309, uri: .munko2309)
    static let munko2310 = Web3Kit.NFT(tokenId: 2310, uri: .munko2310)

}

extension NFTEntity {
    static let munko2309 = NFTEntity(tokenId: "2309", contract: ERC721.Munko.contract.string, uri: .munko2309, metadata: MunkoJSON.data_2309, imageURL: .image2309)
    static let munko2310 = NFTEntity(tokenId: "2310", contract: ERC721.Munko.contract.string, uri: .munko2310, metadata: MunkoJSON.data_2310, imageURL: .image2310)
}

extension ERC721 {
    static var Munko: ERC721 { try! JSONDecoder().decode(ERC721.self, from: MunkoJSON.contract) }
}

extension OpenSeaMetadata {
    static var munko2309: OpenSeaMetadata { try! JSONDecoder().decode(OpenSeaMetadata.self, from: MunkoJSON.data_2309) }
    static var munko2310: OpenSeaMetadata { try! JSONDecoder().decode(OpenSeaMetadata.self, from: MunkoJSON.data_2309) }
}

