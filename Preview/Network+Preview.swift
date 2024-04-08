//
//  Network+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/31/24.
//

import Foundation
import ChainKit

extension NetworkCard {
    static let ETH: NetworkCard = {
//        let card = NetworkCard(chain: 1, rpc: URL(string: "https://google.com")!)
//        card.balance = 400_000_000_000_000_000
//        card.nfts = .preview
//        card.tokens = .preview
        return NetworkCard(evm: .ETH, address: Wallet.rifigy.address)
    }()
}

extension Tokens  {
    static var preview: Tokens {
        let tokens = Tokens()
        tokens.balances = [ .USDC : 1_000_000_000]
        return tokens
    }
}

extension NFTs  {
    static var preview: NFTs {
        let vm = NFTs()
        vm.tokens = [ .Munko : [.munko2309, .munko2310] ]
        return vm
    }
}

extension NetworkEntity {
    static let ETH = NetworkEntity(id: NetworkCard.ETH.id, title: NetworkCard.ETH.name, chain: NetworkCard.ETH.chain, symbol: NetworkCard.ETH.nativeCoin.symbol)
}

struct LocalChain {
    static let ganache_private_key = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
    static let ganache_address = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
}

