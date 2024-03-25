//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt
import Logging
import web3

open class EthereumClient: EthereumClientProtocol {
    
    internal let client: any EthereumClientProtocol
    internal let cache: (any Cache)?
    public let chain: Int
    public let rpc: URL
    
    public init(client: any EthereumClientProtocol, chain: Int, rpc: URL, cache: (any Cache)?) {
        self.client = client
        self.cache = cache
        self.chain = chain
        self.rpc = rpc
    }
    
    public enum Error: Swift.Error {
        case badType
    }
}

extension EthereumClient {

}

extension EthereumClient {
    
    public func send(_ amount: BigUInt, to: String, from account: EthereumAccount, gasPrice: BigUInt?, gasLimit: BigUInt?) async throws -> String {
        try await client.send(amount, to: to, from: account, gasPrice: gasPrice, gasLimit: gasLimit)
    }
    
    public func getReceipt(txHash: String) async throws -> EthereumTransactionReceipt {
        try await client.getReceipt(txHash: txHash)
    }
    
    public func getBalance(address: String, block: Int?) async throws -> BigUInt {
        try await client.getBalance(address: address, block: block)
    }
    
    public func getGasPrice() async throws -> BigUInt {
        try await client.getGasPrice()
    }
    
    public typealias T = EthereumTransaction
    
    public func estimateGas(for tx: Any) async throws -> BigUInt {
        guard let tx = tx as? EthereumTransaction else {throw Error.badType}
        return try await client.estimateGas(for: tx)
        
    }
    
}
