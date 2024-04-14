//
//  File.swift
//  
//
//  Created by Michael on 4/13/24.
//

import Foundation

public struct ContractEntity: Codable, Sendable {
    public let address: String
    public let name: String
    public let symbol: String?
    public let decimals: UInt8?
    
    public init(address: String, name: String, symbol: String?, decimals: UInt8?) {
        self.address = address
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }
    

}

extension ContractEntity: Identifiable, Equatable, Hashable {
    public var id: String { address }

    public static func == (lhs: ContractEntity, rhs: ContractEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



