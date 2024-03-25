//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation

public protocol ERC20Protocol: ERC {
    var decimals: UInt8 {get}
    init(contract: String, name: String?, symbol: String?, decimals: UInt8)
}

public struct ERC20: ERC20Protocol {
    public let contract: String
    public let name: String?
    public let symbol: String?
    public let decimals: UInt8
    
    public init(contract: String, name: String?, symbol: String?, decimals: UInt8) {
        self.contract = contract
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }
}

public extension ERC20 {
    static let USDC = ERC20(contract: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", name: "USD Coin", symbol: "USDC", decimals: 6)
}
