//
//  SwiftUIView.swift
//  
//
//  Created by Michael on 4/13/24.
//

import SwiftUI
import SwiftData

@Observable
public class Token: Codable{
    
    let contract: ContractEntity
    
    public var balance: Double?
    
    public init(address: String, name: String, symbol: String?, decimals: UInt8?, balance: Double? = nil) {
        self.contract = .init(address: address, name: name, symbol: symbol, decimals: decimals)
        self.balance = nil
    }
    
    
    public var address: String { contract.address }
    public var name: String { contract.name }
    public var symbol: String? { contract.symbol }
    public var decimals: UInt8? { contract.decimals }
    
}



extension Token: Identifiable, Equatable, Hashable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id: ContractEntity { contract }
}
