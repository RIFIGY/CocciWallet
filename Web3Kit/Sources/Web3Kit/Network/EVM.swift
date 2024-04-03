//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import SwiftUI

public struct EVM: Codable, Identifiable, Equatable, Hashable {
    public var id: String { chain.description + "_" + rpc.absoluteString }
    public var chain: Int
    public var rpc: URL
    public var name: String
    
    public var symbol: String?
    public var explorer: String?
    
    public var hexColor: String
    
    public var isCustom: Bool
    
    public init(rpc: URL, chain: Int, name: String, symbol: String? = nil, explorer: String? = nil, hexColor: String? = nil, isCustom: Bool) {
        self.rpc = rpc
        self.chain = chain
        self.name = name
        self.symbol = symbol?.uppercased()
        self.explorer = explorer
        self.hexColor = hexColor ?? "#627eea"
        self.isCustom = isCustom
    }
}

extension EVM {
    
    public static let selection: [EVM] = [.ETH, .BNB, .ARB, .AVAX, .MATIC]
    
    fileprivate init(chain: Int, name: String, symbol: String? = nil, explorer: String? = nil, color: String? = nil) {
        self.rpc = Llama.URL(name)
        self.chain = chain
        self.name = name
        self.symbol = symbol?.uppercased()
        self.explorer = explorer
        self.hexColor = color ?? "#627eea"
        self.isCustom = false
    }
    
    public static let ETH = EVM(
        chain: 1,
        name: "Ethereum",
        symbol: "ETH",
        explorer: "etherscan.io",
        color: "#627eea"
    )
    
    public static let BNB = EVM(
        chain: 56,
        name:"Binance",
        symbol: "BNB",
        color: "#f3ba2f"
    )
    
    public static let ARB = EVM(
        chain: 42161,
        name: "Arbitrum",
        symbol: "ARB",
        color: "#162C4E"

    )
    
    public static let AVAX = EVM(
        chain: 43114,
        name: "Avalanche",
        symbol: "AVAX",
        explorer: "snowtrace.io",
        color: "#e84142"
    )
    
    public static let MATIC = EVM(
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
