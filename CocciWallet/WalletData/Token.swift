//
//  SwiftUIView.swift
//  
//
//  Created by Michael on 4/13/24.
//

import SwiftUI
import SwiftData

@Model
public class Token {
    
    let contract: ContractEntity
    
    public var balance: Double?
    
    public init(address: String, name: String, symbol: String?, decimals: UInt8?, balance: Double? = nil) {
        self.contract = .init(address: address, name: name, symbol: symbol, decimals: decimals)
        self.balance = nil
    }
    
    public init(contract: ContractEntity, balance: Double? = nil) {
        self.contract = contract
        self.balance = balance
    }
    
    
    public var address: String { contract.address }
    public var name: String { contract.name }
    public var symbol: String? { contract.symbol }
    public var decimals: UInt8? { contract.decimals }
    
}

import Web3Kit
extension Token {
    
    @MainActor
    func fetchBalance(for address: String, with client: EthClient) async throws {
        let balance = try await client.fetchTokenBalance(contract: contract.address, address: address)
        let value = balance.double(self.decimals ?? 18)
        print("\t\(name) \(value.formatted(.number))")
        self.balance = value
    }
}

