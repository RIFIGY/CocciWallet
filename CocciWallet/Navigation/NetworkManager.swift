//
//  NetworkManager.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import Foundation
import Web3Kit

@Observable
class NetworkManager {
    private let cache: any Cache

    private var clients: [EVM : EthereumClient ] = [:]
    
    var showNewNetwork = false

    var coingeckoIds: [String] { clients.keys.compactMap{ $0.coingecko } }
            
    init(cache: any Cache = UserDefaults.standard) {
        self.cache = cache
        
        Wallet.fetchWallets(from: cache).forEach { wallet in
            let cards = wallet.cards(from: cache, custom: false)
            let custom = wallet.cards(from: cache, custom: true)
             (cards + custom).forEach {
                 add(evm: $0)
             }
         }
    }
    
    func add(evm: EVM) {
        guard clients[evm] == nil,
              let infuraURL = Infura.shared.URL(evm: evm) else {return}
        
        let client = EthereumClient(rpc: infuraURL, chain: evm.chain)
        
        clients[evm] = client
    }
    
    
    func getClient(_ evm: EVM) -> EthereumClient {
        if let client = clients[evm] {
            return client
        } else {
            let url = Infura.shared.URL(evm: evm) ?? evm.rpc
            let client = EthereumClient(rpc: url, chain: evm.chain)
            clients[evm] = client
            return client
        }
    }
    
//    var prices: [ String : [String : Double] ] {priceModel.prices}
//    var platformPrices: [ PlatformID : [String:Double] ] { priceModel.platformPrices }
//    var priceHistory: [String : CoinGecko.Prices ] {priceModel.priceHistory}
    

}
