//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/27/24.
//

import Foundation

public protocol CoinProtocol: Codable {
    var symbol: String { get }
    var name: String { get }
    var decimals: UInt8 { get }
}

public protocol CoinType: Codable, Identifiable {
    var derivation: UInt32 { get }
    var symbol: String { get }
    var name: String { get }
}
extension CoinType {
    public var id: UInt32 { derivation }
}

public struct AnyCoinType: CoinType {
    public var id: UInt32 { derivation }
    public let name: String
    public let symbol: String
    public let derivation: UInt32
}


extension AnyCoinType {
    public static var ETH: AnyCoinType { AnyCoinType(name: "Ethereum", symbol: "ETH", derivation: 60) }
    public static var BTC: AnyCoinType { AnyCoinType(name: "Bitcoin", symbol: "BTC", derivation: 00) }
    
    public static var TestNet: some CoinType { AnyCoinType(name: "TestNet", symbol: "TEST", derivation: 01) }
}
