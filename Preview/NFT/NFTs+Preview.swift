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



extension NFTMetadata {
    
    fileprivate convenience init(contract: any Contract, tokenId: BigUInt, uri: URL?, json: Data? = nil, imageURL: URL? = nil) {
        self.init(tokenId: tokenId, contract: contract.contract.string, contractName: contract.name, symbol: contract.symbol, uri: uri, json: json)
        self.imageURL = imageURL
    }
    
    static let munko2309 = NFTMetadata(
        contract: ERC721.Munko,
        tokenId: 2309,
        uri: URL(string: "ipfs://bafybeihbys33ageiel4lcfvfbppwnsayzwtesz4hcuq7iv4hhcjqc2lhte/2309"),
        json: OpenSeaMetadata.muko2309MetadataJSON,
        imageURL: URL(string: "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/e703713595264f15bb3363380a1fe55bee7798a85705495aa607d4b3c420b8ae.jpg")!
    )
    
    static let munko2310 = NFTMetadata(
        contract: ERC721.Munko,
        tokenId: 2310,
        uri: URL(string: "ipfs://bafybeihbys33ageiel4lcfvfbppwnsayzwtesz4hcuq7iv4hhcjqc2lhte/2310"),
        json: OpenSeaMetadata.munko2310MetadataJSON,
        imageURL: URL(string: "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/d9c8d4b7886844779f25fb44fc721117eb0d290415c54a03926e3f0d0f3e1590.jpg")
    )
}

extension ContractEntity {
    static let munko = ContractEntity(contract: ERC721.Munko)
}
extension NftEntity {
    static let munko2309 = NftEntity(nft: .munko2309)
    static let munko2310 = NftEntity(nft: .munko2310)
}
extension NFTIntent {
    
    static var m2309: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = []
        return intent
    }
    
    static var m2310: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2310
        intent.showBackground = true

        intent.randomNFT = false
        intent.nfts = []
        
        return intent
    }
    
    static var m2309_4: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = [.munko2309, .munko2310, .munko2309, .munko2310]
        return intent
    }
    
    static var m2309_2: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = [.munko2309, .munko2310]
        return intent
    }
    

}


