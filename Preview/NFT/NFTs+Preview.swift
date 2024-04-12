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
import WalletData


extension WalletData.NFT {
    
    fileprivate convenience init(contract: any Contract, tokenId: BigUInt, uri: URL?, json: Data? = nil, imageURL: URL? = nil) {
        self.init(tokenId: tokenId, contract: contract.contract.string, contractName: contract.name, symbol: contract.symbol, uri: uri, json: json)
        self.imageURL = imageURL
    }
    
    static let munko2309 = WalletData.NFT(
        contract: ERC721.Munko,
        tokenId: 2309,
        uri: URL(string: "ipfs://bafybeihbys33ageiel4lcfvfbppwnsayzwtesz4hcuq7iv4hhcjqc2lhte/2309"),
        json: OpenSeaMetadata.muko2309MetadataJSON,
        imageURL: URL(string: "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/e703713595264f15bb3363380a1fe55bee7798a85705495aa607d4b3c420b8ae.jpg")!
    )
    
    static let munko2310 = WalletData.NFT(
        contract: ERC721.Munko,
        tokenId: 2310,
        uri: URL(string: "ipfs://bafybeihbys33ageiel4lcfvfbppwnsayzwtesz4hcuq7iv4hhcjqc2lhte/2310"),
        json: OpenSeaMetadata.munko2310MetadataJSON,
        imageURL: URL(string: "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/d9c8d4b7886844779f25fb44fc721117eb0d290415c54a03926e3f0d0f3e1590.jpg")
    )
}




