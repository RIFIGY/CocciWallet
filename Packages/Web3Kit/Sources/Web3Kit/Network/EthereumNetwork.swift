//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import SwiftUI
import ChainKit

public struct EthereumNetwork: ChainKit.EthereumNetwork, Codable, Identifiable, Equatable, Hashable {
    public var id: String
    public var chain: Int
    public var rpc: URL
    public let nativeCoin: Coin

    public var explorerPrefix: String?
    
    public var hexColor: String
    
    public var isCustom: Bool
    
    
    public init
    (rpc: URL,
     chain: Int,
     name: String,
     symbol: String? = nil,
     explorer: String? = nil,
     hexColor: String? = nil,
     isCustom: Bool
    ) {
        self.id = chain.description + "_" + rpc.absoluteString
        self.rpc = rpc
        self.chain = chain
        self.nativeCoin = .init(derivation: 60, symbol: symbol?.uppercased() ?? "", name: name, decimals: 18)
        self.explorerPrefix = explorer
        self.hexColor = hexColor ?? "#627eea"
        self.isCustom = isCustom
    }
}

extension EthereumNetwork {
    
    public static let selection: [EthereumNetwork] = [.ETH, .BNB, .ARB, .AVAX, .MATIC]
    
    fileprivate init(chain: Int, name: String, symbol: String? = nil, explorer: String? = nil, color: String? = nil) {
        self.id = name
        self.rpc = Llama.URL(name)
        self.chain = chain
        self.nativeCoin = .init(derivation: 60, symbol: symbol?.uppercased() ?? "", name: name, decimals: 18)
        self.explorerPrefix = explorer
        self.hexColor = color ?? "#627eea"
        self.isCustom = false
    }
    
    public static let ETH = EthereumNetwork(
        chain: 1,
        name: "Ethereum",
        symbol: "ETH",
        explorer: "etherscan.io",
        color: "#627eea"
    )
    
    public static let BNB = EthereumNetwork(
        chain: 56,
        name:"Binance",
        symbol: "BNB",
        color: "#f3ba2f"
    )
    
    public static let ARB = EthereumNetwork(
        chain: 42161,
        name: "Arbitrum",
        symbol: "ARB",
        color: "#162C4E"

    )
    
    public static let AVAX = EthereumNetwork(
        chain: 43114,
        name: "Avalanche",
        symbol: "AVAX",
        explorer: "snowtrace.io",
        color: "#e84142"
    )
    
    public static let MATIC = EthereumNetwork(
        chain: 137,
        name: "Polygon",
        symbol: "MATIC",
        explorer: "polygonscan.com",
        color: "#6f41d8"
    )
}



fileprivate struct Llama {
    fileprivate static func URL(_ name: String) -> Foundation.URL {
        let name = name == "Ethereum" ? "eth" : name
        return Foundation.URL(string: "https://\(name.lowercased()).llamarpc.com")!
    }
}
