//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import web3
import BigInt

extension web3.EthereumHttpClient: EthereumClientProtocol  {
    
    public typealias Account = EthereumAccount
    public var rpc: URL {
        self.url
    }
    
    public var chain: Int {
        self.network.intValue
    }
        
    public func getBalance(address: String, block: Int? = nil) async throws -> BigUInt {
        try await self.eth_getBalance(
            address: try validate(address),
            block: validate(block)
        )
    }

    
    public func getGasPrice() async throws -> BigUInt {
        try await self.eth_gasPrice()
    }

    
    public func estimateGas(for tx: Any) async throws -> BigUInt {
        guard let tx = tx as? EthereumTransaction else { throw EthereumClient<EthereumHttpClient>.Error.badType }
        return try await self.eth_estimateGas(tx)
    }
    
    public func send(_ amount: BigUInt, to: String, from account: EthereumAccount, gasPrice: BigUInt?, gasLimit: BigUInt?) async throws -> String {

        let nonce = try await self.eth_getTransactionCount(address: account.address, block: .Latest)
        print("Nonce \(nonce)")


        let tx = EthereumTransaction(
            from: account.address,
            to: .init(to),
            value: amount,
            data: nil,
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            chainId: self.chain
        )
        
        return try await self.eth_sendRawTransaction(tx, withAccount: account)
    }
    
    
    public func getReceipt(txHash: String) async throws -> EthereumTransactionReceipt {
        try await self.eth_getTransactionReceipt(txHash: txHash)
    }
}


