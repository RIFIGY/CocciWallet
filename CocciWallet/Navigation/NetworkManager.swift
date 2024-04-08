//
//  NetworkManager.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import Foundation
import Web3Kit
import OffChainKit

@Observable
class NetworkManager {
    private let cache: any Cache

    private var clients: [EthereumNetwork : EthereumClient ] = [:]
    
    var showNewNetwork = false

    var coingeckoIds: [String] { clients.keys.compactMap{ CoinGecko.AssetPlatform.NativeCoin(chainID: $0.chain) } }
            
    init(cache: any Cache = UserDefaults.group) {
        self.cache = cache
        
        let wallets = Storage.shared.Wallets()
        
        wallets.forEach { wallet in
            let cards = wallet.cards + wallet.custom
            cards.forEach { card in
                 add(card: card)
             }
        }
    }
    
    func add(card: NetworkCard) {
//        let evm = EthereumNetwork(rpc: card.rpc, chain: card.chain, name: card.title, symbol: card.symbol, explorer: card.explorer, hexColor: card.color.hexString, isCustom: card.isCustom)
//        guard clients[evm] == nil,
//              let infuraURL = Infura.shared.URL(evm: evm) else {return}
//        
//        let client = EthClient(rpc: infuraURL, chain: evm.chain)
//        
//        clients[evm] = client
    }
    
    func getClient(chain: Int) -> EthereumClient? {
        clients.first{ key, _ in key.chain == chain }?.value
    }
    
    func getClient(_ card: NetworkCard) -> EthereumClient {
        .init(rpc: card.rpc, chain: card.chain)
//        let evm = EthereumNetwork(rpc: card.rpc, chain: card.chain, name: card.title, symbol: card.symbol, explorer: card.explorer, hexColor: card.color.hexString, isCustom: card.isCustom)
//        if let client = clients[evm] {
//            return client
//        } else {
//            let url = Infura.shared.URL(evm: evm) ?? evm.rpc
//            let client = EthClient(rpc: url, chain: evm.chain)
//            clients[evm] = client
//            return client
//        }
    }
    
    func getClient(_ evm: EthereumNetwork) -> EthereumClient {
        .init(rpc: evm.rpc, chain: evm.chain)

//        if let client = clients[evm] {
//            return client
//        } else {
//            let url = Infura.shared.URL(evm: evm) ?? evm.rpc
//            let client = EthClient(rpc: url, chain: evm.chain)
//            clients[evm] = client
//            return client
//        }
    }
}
