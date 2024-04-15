//
//  Network.swift
//  CocciWallet
//
//  Created by Michael on 4/7/24.
//

import SwiftUI
import Web3Kit

extension Network {
    
    var address: Web3Kit.EthereumAddress { .init(addressString) }
    
    var color: Color {
        Color(hex: hexColor)!
    }
        
    var isCustom: Bool {
        !NetworkEntity.chains.contains(self.chain)
    }
}



extension NetworkEntity {
    
    static let selection: [NetworkEntity] = [.ETH, .ARB, .AVAX, .MATIC] // .BNB]
    
    static let chains: [Int] = selection.map{$0.chain}
    
    fileprivate init(chain: Int, rpc: URL? = nil, name: String, coin: String? = nil, symbol: String, explorer: String? = nil, color: String) {
        self.chain = chain
        let rpc = rpc ?? Infura.shared.URL(chainInt: chain)!
        self.rpc = rpc
        self.hexColor = color
        self.name = name
        self.coin = coin ?? name
        self.symbol = symbol
        self.decimals = 18
        self.explorer = explorer ?? ""
    }
    
    static let ETH = NetworkEntity(
        chain: 1,
        name: "Ethereum",
        symbol: "ETH",
        explorer: "etherscan.io",
        color: "#627eea"
    )
    
    static let MATIC = NetworkEntity(
        chain: 137,
        name: "Polygon",
        symbol: "MATIC",
        explorer: "polygonscan.com",
        color: "#6f41d8"
    )
    static let ARB = NetworkEntity(
        chain: 42161,
        name: "Arbitrum",
        symbol: "ARB",
        color: "#162C4E"
    )
    
    static let AVAX = NetworkEntity(
        chain: 43114,
        name: "Avalanche",
        symbol: "AVAX",
        explorer: "snowtrace.io",
        color: "#e84142"
    )
    

}

extension NetworkEntity {
    static func Local(url: URL? = nil) -> NetworkEntity {
        NetworkEntity(
            chain: 1337,
            rpc: url ?? URL(string: "HTTP://127.0.0.1:7545")!,
            name: "Ganache",
            symbol: "TEST",
            explorer: "etherscan.io",
            color: "#1b9e65"
        )
    }
}
