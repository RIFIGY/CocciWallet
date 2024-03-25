//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import web3
import BigInt

extension web3.EthereumHttpClient: EthereumClientProtocol {
    
    public var rpc: URL {
        self.url
    }
    
    public var chain: Int {
        self.network.intValue
    }
    
    internal func validate(_ address: String) throws -> EthereumAddress {
        guard let _ = address.web3.hexData else {
            throw EthereumClientError.noInputData
        }
        return .init(address)
    }
    
    internal func validate(_ block: Int?) -> EthereumBlock {
        if let block {
            return .init(rawValue: block)
        } else {
            return .Latest
        }
    }
    
    public func getBalance(address: String, block: Int? = nil) async throws -> BigUInt {
        try await self.eth_getBalance(
            address: try validate(address),
            block: validate(block)
        )
    }
    
    public func getReceipt(txHash: String) async throws -> EthereumTransactionReceipt {
        try await self.eth_getTransactionReceipt(txHash: txHash)
    }
    
    public func getGasPrice() async throws -> BigUInt {
        try await self.eth_gasPrice()
    }

    
    public func estimateGas(for tx: Any) async throws -> BigUInt {
        guard let tx = tx as? EthereumTransaction else {throw EthereumClient.Error.badType}
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
    
//    func send(_ amount: BigUInt, to: String, from account: EthereumAccount) async throws -> String {
//        let gasPrice = try await self.getGasPrice()
////        let nonce = try await self.eth_getTransactionCount(address: account.address, block: .Latest)
//        let nonce = try await self.eth_getTransactionCount(address: account.address, block: .Latest)
//        
//        var tx = EthereumTransaction(
//            from: account.address,
//            to: .init(to),
//            value: amount,
//            data: nil,
//            nonce: nonce,
//            gasPrice: gasPrice,
//            gasLimit: BigUInt(5_000_000),
//            chainId: self.chain
//        )
//        let estimatedGas = try await self.estimateGas(for: tx)
//
//        tx = EthereumTransaction(
//            from: account.address,
//            to: .init(to),
//            value: amount,
//            data: nil,
//            nonce: nonce,
//            gasPrice: gasPrice,
//            gasLimit: estimatedGas,
//            chainId: self.chain
//        )
//        return try await self.eth_sendRawTransaction(tx, withAccount: account)
//
//    }
    
}


extension EthereumClient {
    public convenience init(rpc: URL, chain: Int, cache: (any Cache)? = nil) {
        let client = EthereumHttpClient(
            url: rpc,
            network: .custom(chain.description)
        )
        self.init(client: client, chain: chain, rpc: rpc, cache: cache)
    }
}

