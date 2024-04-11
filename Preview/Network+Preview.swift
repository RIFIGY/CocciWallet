//
//  Network+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/31/24.
//

import Foundation
import ChainKit

extension EthereumNetworkCard {
    static let preview: EthereumNetworkCard = {
        let card = EthereumNetworkCard(address: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", chain: 1, rpc: URL(string: "https://google.com")!, name: "Ethereum", symbol: "ETH", hexColor: "#627eea")
        card.balance = 400_000_000_000_000_000
//        card.nfts = [ .Munko : [] ]
        card.tokens = [ .USDC : 1_000_000_000]
        return card
    }()
}

extension NetworkEntity {
    static let ETH = NetworkEntity(id: EthereumCardEntity.ETH.chain.description, title: EthereumCardEntity.ETH.name, symbol: EthereumCardEntity.ETH.symbol)
}

struct LocalChain {
    static let ganache_private_key = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
    static let ganache_address = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
}

