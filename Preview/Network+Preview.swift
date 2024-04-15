//
//  Network+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/31/24.
//

import Foundation
import ChainKit

extension Network {
    static let preview: Network = previewETH
    
    static let previewETH: Network = {
        var card = Network(address: "", card: .ETH)
//        card.nfts = [ .Munko : [ .munko2309, .munko2310] ]
//        card.balanceString = "400000000000000000"
//        card.nfts = [ .Munko : [] ]
//        card.tokens = [ .USDC : 1_000_000_000]
        return card
    }()
    
    static let previewMatic: Network = {
        var card = Network(address: "", card: .MATIC)
//        card.balanceString = "400000000000000000"
//        card.nfts = [ .Munko : [] ]
//        card.tokens = [ .USDC : 1_000_000_000]
        return card
    }()
}



struct LocalChain {
    static let ganache_private_key = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
    static let ganache_address = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
}

