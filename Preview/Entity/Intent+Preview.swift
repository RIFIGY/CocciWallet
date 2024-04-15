//
//  Intent+Preview.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import Foundation

extension NFTIntent {
    static var m2309: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
//        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = []
        return intent
    }
    
    static var m2310: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
//        intent.nft = .munko2310
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
//        intent.nft = .munko2309
        intent.randomNFT = false
//        intent.nfts = [.munko2309, .munko2310, .munko2309, .munko2310]
        return intent
    }
    
    static var m2309_2: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
//        intent.nft = .munko2309
        intent.randomNFT = false
//        intent.nfts = [.munko2309, .munko2310]
        return intent
    }
    

}


extension TokenIntent {
    static var usdc: TokenIntent {
        let intent = TokenIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .usdc
        intent.currency = "usd"
        intent.showBalance = true
        intent.showFiat = false
        intent.showBackground = true
        return intent
    }
    
    static var usdcB: TokenIntent {
        let intent = TokenIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .usdc
        intent.currency = "usd"
        intent.showBalance = false
        intent.showFiat = false
        intent.showBackground = false
        return intent
    }
}
