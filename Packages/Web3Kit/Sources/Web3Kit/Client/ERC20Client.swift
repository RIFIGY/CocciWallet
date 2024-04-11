//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt
import ChainKit

public protocol ERC20Client {
    func getBalance(contract: EthereumAddress, address: EthereumAddress) async throws -> BigUInt
    func getContract(address contract: EthereumAddress) async throws -> ERC20
    func getTransferEvents(for address: EthereumAddress) async throws -> [ERC20Transfer]
}


extension ERC20Client {

    
    public func fetchBalances(for address: EthereumAddress, in contracts: [EthereumAddress]) async throws -> [(ERC20, BigUInt)] {
        
        try await withThrowingTaskGroup(of: (ERC20,BigUInt)?.self) { group in
            
            contracts.forEach { contract in
                group.addTask {
                    async let erc20 = try await getContract(address: contract)
                    async let balance = try await getBalance(contract: contract, address: address)
                    
                    return try? await (erc20, balance)
                }
            }
            
            return try await group.reduce(into: [ (ERC20, BigUInt) ]()) { partialResult, balance in
                if let balance {
                    partialResult.append(balance)
                }
            }
        }
    }
}
