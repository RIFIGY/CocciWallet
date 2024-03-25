//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import BigInt
import web3
import Logging

extension EthereumClient: ERC20Client {
    
    public func getERC20balance(contract: String, address: String) async throws -> BigUInt {
        try await client.getERC20balance(contract: contract, address: address)
    }
    
    public func getERC20Contract(for contract: String) async throws -> ERC20 {
        if let contract = cache?.fetch(ERC20.self, for: contract) { return contract }
        
        let erc20 = try await client.getERC20Contract(for: contract)
        cache?.store(erc20, forKey: contract)
        
        return erc20
    }
    
    public func getERC20events(for address: String) async throws -> [ERC20Transfer] {
        try await client.getERC20events(for: address)
    }
}
