//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt

public protocol ERC20Client {
    
    func getERC20balance(contract: String, address: String) async throws -> BigUInt
    
    func getERC20Contract(for contract: String) async throws -> ERC20
    
    func getERC20events(for address: String) async throws -> [ERC20Transfer]
    
}

extension ERC20Client {
    public func fetchBalances(for address: String, in contracts: [String]) async throws -> [(ERC20, BigUInt)] {
        
        try await withThrowingTaskGroup(of: (ERC20,BigUInt).self) { group in
            
            contracts.forEach { contract in
                group.addTask {
                    async let erc20 = try await getERC20Contract(for: contract)
                    async let balance = try await getERC20balance(contract: contract, address: address)
                    
                    return try await (erc20, balance)
                }
            }
            
            return try await group.reduce(into: [ (ERC20, BigUInt) ]()) { partialResult, balance in
                partialResult.append(balance)
            }
        }
    }
}
