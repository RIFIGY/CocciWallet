//
//  EthereumNetworkCard.swift
//  CocciWallet
//
//  Created by Michael on 4/7/24.
//

import Foundation
import Web3Kit
import ChainKit
import BigInt
import Logging
import OffChainKit
import SwiftUI
import SwiftData
import WalletData

typealias Wallet = PrivateKeyWallet
typealias EthereumNetworkCard = Web3Network

extension EthereumNetworkCard {
    
    init(evm: EthereumCardEntity, address: Web3Kit.EthereumAddress){
        self.init(address: address, chain: evm.chain, rpc: evm.rpc, name: evm.name, symbol: evm.symbol, hexColor: evm.color)
    }
        
    
//    func update(clients network: NetworkManager, prices: Prices, currency: String) async -> Bool {
//        guard let client = network.getClient(chain: self.chain) else {return false}
//        let updated = await self.update(with: client.node) { address, explorer in
//            try await Etherscan.shared.getTransactions(for: address, explorer: explorer)
//        }
//
//        if updated {
//            let contracts = self.tokens.map{$0.key.contract.string}
//            await prices.fetchPrices(chain: self.chain, contracts: contracts, currency: currency)
//        }
//        return updated
//    }
    
    var color: Color {
        Color(hex: hexColor)!
    }
    
    var value: Double? {
        balance?.value(decimals: decimals)
    }
    

    
    var isCustom: Bool {
        #warning("fix this")
        return false
//        .selection.map{$0.id}.contains(id)
    }
}



struct EthereumCardEntity: Identifiable {
    
    static let selection: [EthereumCardEntity] = [.ETH, .ARB, .AVAX, .MATIC] // .BNB]
    static var chains: [Int] { selection.map{$0.chain} }
    var id: String { chain.description }
    
    let chain: Int
    let rpc: URL
    let name: String
    let symbol: String
    var explorer: String? = nil
    let color: String
    
    init(chain: Int, rpc: URL? = nil, name: String, symbol: String, explorer: String? = nil, color: String) {
        self.chain = chain
        let rpc = rpc ?? Infura.shared.URL(chainInt: chain)!
        self.rpc = rpc
        self.name = name
        self.symbol = symbol
        self.explorer = explorer
        self.color = color
    }
    
    static let ETH = EthereumCardEntity(
        chain: 1,
        name: "Ethereum",
        symbol: "ETH",
        explorer: "etherscan.io",
        color: "#627eea"
    )
    
//    static let BNB = EthereumCardEntity(
//        chain: 56,
//        name:"Binance",
//        symbol: "BNB",
//        color: "#f3ba2f"
//    )
    
    static let MATIC = EthereumCardEntity(
        chain: 137,
        name: "Polygon",
        symbol: "MATIC",
        explorer: "polygonscan.com",
        color: "#6f41d8"
    )
    static let ARB = EthereumCardEntity(
        chain: 42161,
        name: "Arbitrum",
        symbol: "ARB",
        color: "#162C4E"
    )
    
    static let AVAX = EthereumCardEntity(
        chain: 43114,
        name: "Avalanche",
        symbol: "AVAX",
        explorer: "snowtrace.io",
        color: "#e84142"
    )
    

}

extension EthereumCardEntity {
    static func Local(url: URL? = nil) -> EthereumCardEntity {
        EthereumCardEntity(
            chain: 1337,
            rpc: url ?? URL(string: "HTTP://127.0.0.1:7545")!,
            name: "Ganache",
            symbol: "TEST",
            explorer: "etherscan.io",
            color: "#1b9e65"
        )
    }
}
