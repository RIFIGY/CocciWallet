//
//  Network+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/31/24.
//

import Foundation

extension NetworkCard {
    static let ETH: NetworkCard = {
        let card = NetworkCard(evm: .ETH, address: Wallet.rifigy.address)
        card.nftInfo.tokens = [.Munko: [ .munko2309, .munko2310 ] ]
        card.balance = 400_000_000_000_000_000
        card.tokenInfo.balances = [ .USDC : 1_000_000_000]
//        card.nftInfo.nfts = [.init(nft: .munko2309)]
        return card
    }()
}

extension NetworkEntity {
    static let ETH = NetworkEntity(id: NetworkCard.ETH.id, title: NetworkCard.ETH.title, chain: NetworkCard.ETH.chain, symbol: NetworkCard.ETH.symbol)
}

struct LocalChain {
    static let ganache_private_key = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
    static let ganache_address = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
}

