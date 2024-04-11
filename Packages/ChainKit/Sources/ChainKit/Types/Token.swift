//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation

public protocol Contract: Codable, Identifiable, Hashable, Equatable {
    associatedtype Address : ChainKit.Address
    var contract: Address { get }
    var name: String {get}
    var symbol: String {get}
    var decimals: UInt8 {get}
}
public extension Contract {
    var id: Address { contract }
    var isNFT: Bool { self.decimals <= 0 }
    var title: String {
        if name.isEmpty {
            if symbol.isEmpty {
                String(contract.string.suffix(8))
            } else {
                symbol
            }
        } else {
            name
        }
    }
}


public struct Token<A:ChainKit.Address>: Contract {
    public var id: A { contract }
    public let contract: A
    public let name: String
    public let symbol: String
    public let decimals: UInt8
    
    public init(contract: A, name: String, symbol: String, decimals: UInt8) {
        self.contract = contract
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }
}

