//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation

public struct Coin: CoinProtocol, CoinType {
    public var id: UInt32 { derivation }
    public let derivation: UInt32
    
    public let symbol: String
    public let name: String
    public let decimals: UInt8
    
    public init(derivation: UInt32, symbol: String, name: String, decimals: UInt8) {
        self.derivation = derivation
        self.symbol = symbol
        self.name = name
        self.decimals = decimals
    }
}

