//
//  NetworkManager.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import Foundation
import Web3Kit
import OffChainKit
import WalletData

@Observable
class NetworkManager {

    private var web3: [Int : EthereumClient ] = [:]
    
    var showNewNetwork = false

    var coingeckoIds: [String] {
        web3.keys.compactMap{
            CoinGecko.AssetPlatform.NativeCoin(chainID: $0)
        }
    }
            
    init() {
        
        Task {
            let wallets = await WalletContainer.shared.allWallets()
            
            wallets.forEach { wallet in
                wallet.networks.forEach { evm in
                    self.add(network: evm)
                 }
            }
        }
    }
    

    func add(network: Web3Network) {
        let chain = network.chain
        guard web3[chain] == nil,
                let infuraURL = Infura.shared.URL(chainInt: chain) else {return}
        let client = EthereumClient(rpc: infuraURL, chain: chain)
        self.web3[chain] = client
    }
    
    func getClient(chain: Int, rpc: URL? = nil) -> EthereumClient? {
        if let client = web3[chain] {
            return client
        } else if let url = Infura.shared.URL(chainInt: chain) {//?? rpc {
            let client = EthereumClient(rpc: url, chain: chain)
            self.web3[chain] = client
            return client
        } else {
            return nil
        }
    }
}
