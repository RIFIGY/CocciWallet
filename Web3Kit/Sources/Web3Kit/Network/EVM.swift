//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import SwiftUI

public struct EVM: Codable, Identifiable, Equatable, Hashable {
    public var id: String { chain.description + "_" + rpc.absoluteString }
    public let chain: Int
    public let rpc: URL
    public let name: String?

    public var title: String?
    public var symbol: String?
    public var explorer: String?
    
    public var color: Color
    
    public init(rpc: URL, chain: Int, name: String?, title: String? = nil, symbol: String? = nil, explorer: String? = nil, color: Color? = nil) {
        self.rpc = rpc
        self.chain = chain
        self.name = name
        self.title = title
        self.symbol = symbol?.uppercased()
        self.explorer = explorer
        self.color = color ?? .ETH
    }
}

extension EVM {
    
    #warning("remove custom for productiton")
    public var coingecko: String? {
        if self.rpc.absoluteString.lowercased() == "HTTP://127.0.0.1:7545".lowercased() {
            return "ethereum"
        }
        return CoinGecko.PlatformID(self)
    }
    
    public static let selection: [EVM] = [.ETH, .BNB, .ARB, .AVAX, .MATIC]
    
    fileprivate init(chain: Int, name: String?, title: String? = nil, symbol: String? = nil, explorer: String? = nil, color: Color? = nil) {
        self.rpc = Llama.URL(name!)
        self.chain = chain
        self.name = name
        self.title = title
        self.symbol = symbol?.uppercased()
        self.explorer = explorer
        self.color = color ?? .ETH
    }
    
    public static let ETH = EVM(
        chain: 1,
        name: "Ethereum",
        symbol: "ETH",
        explorer: "etherscan.io",
        color: .ETH
    )
    
    public static let BNB = EVM(
        chain: 56,
        name:"Binance",
        title: "BNB Smart Chain",
        symbol: "BNB",
        color: .orange
    )
    
    public static let ARB = EVM(
        chain: 42161,
        name: "Arbitrum",
        title: "Arbitrum One",
        symbol: "ARB",
        color: .ETH

    )
    
    public static let AVAX = EVM(
        chain: 43114,
        name: "Avalanche",
        symbol: "AVAX",
        explorer: "snowtrace.io",
        color: .init(hex: "#e84142")
    )
    
    public static let MATIC = EVM(
        chain: 137,
        name: "Polygon",
        symbol: "MATIC",
        explorer: "polygonscan.com",
        color: .init(hex: "#6f41d8")
    )
}




public extension Color {
    static let ETH = Color(hex: "#627eea")!
}

private struct Llama {
    public static func URL(_ name: String) -> Foundation.URL {
        let name = name == "Ethereum" ? "eth" : name
        return Foundation.URL(string: "https://\(name.lowercased()).llamarpc.com")!
    }
}
