////
////  File.swift
////  
////
////  Created by Michael Wilkowski on 3/10/24.
////
//
//import SwiftUI
//import ChainKit
//
//public struct EthereumNetwork: ChainKit.EthereumNetwork, Codable, Identifiable, Equatable, Hashable {
//    public var id: String
//    public var chain: Int
//    public var rpc: URL
//    public let nativeCoin: Coin
//
//    public var explorerPrefix: String?
//    
//    public var hexColor: String
//    
//    public var isCustom: Bool
//    
//    
//    public init
//    (rpc: URL,
//     chain: Int,
//     name: String,
//     symbol: String? = nil,
//     explorer: String? = nil,
//     hexColor: String? = nil,
//     isCustom: Bool
//    ) {
//        self.id = chain.description + "_" + rpc.absoluteString
//        self.rpc = rpc
//        self.chain = chain
//        self.nativeCoin = .init(derivation: 60, symbol: symbol?.uppercased() ?? "", name: name, decimals: 18)
//        self.explorerPrefix = explorer
//        self.hexColor = hexColor ?? "#627eea"
//        self.isCustom = isCustom
//    }
//}
//
//
//
//
//fileprivate struct Llama {
//    fileprivate static func URL(_ name: String) -> Foundation.URL {
//        let name = name == "Ethereum" ? "eth" : name
//        return Foundation.URL(string: "https://\(name.lowercased()).llamarpc.com")!
//    }
//}
