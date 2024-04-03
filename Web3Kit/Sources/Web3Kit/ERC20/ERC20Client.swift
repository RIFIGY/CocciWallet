//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt

public protocol ERC20Client {
    
    associatedtype T : ERCTransfer
    associatedtype E : ERC20Protocol
    
    func getBalance(contract: String, address: String) async throws -> BigUInt
    func getContract(address contract: String) async throws -> E
    func getTransferEvents(for address: String) async throws -> [T]
    
}

extension ERC20Client {
    
    public func fetchBalances(for address: String, in contracts: [String]) async throws -> [(E, BigUInt)] {
        
        try await withThrowingTaskGroup(of: (E,BigUInt)?.self) { group in
            
            contracts.forEach { contract in
                group.addTask {
                    async let erc20 = try await getContract(address: contract)
                    async let balance = try await getBalance(contract: contract, address: address)
                    
                    return try? await (erc20, balance)
                }
            }
            
            return try await group.reduce(into: [ (E, BigUInt) ]()) { partialResult, balance in
                if let balance {
                    partialResult.append(balance)
                }
            }
        }
    }
}
