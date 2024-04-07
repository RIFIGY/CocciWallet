//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/27/24.
//

import Foundation

public protocol Coin: Codable {
    var symbol: String { get }
    var name: String { get }
    var decimals: UInt8 { get }
}

public protocol CoinType: Codable, Identifiable {
    var id: UInt32 { get }
    var symbol: String { get }
    var name: String { get }
}

public struct AnyCoinType: CoinType {
    public let name: String
    public let symbol: String
    public let id: UInt32
}


extension AnyCoinType {
    public static var ETH: AnyCoinType { AnyCoinType(name: "Ethereum", symbol: "ETH", id: 60) }
    public static var BTC: AnyCoinType { AnyCoinType(name: "Bitcoin", symbol: "BTC", id: 00) }
    
    public static var TestNet: some CoinType { AnyCoinType(name: "TestNet", symbol: "TEST", id: 01) }
}
