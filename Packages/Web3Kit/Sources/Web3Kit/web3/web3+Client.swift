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

    
    public typealias NFT = Web3Kit.NFT
    public typealias Account = EthereumAccount
    public typealias Metadata = OpenSeaMetadata
    
            
    
    public func fetchTokens(for address: EthereumAddress) async throws -> [ERC20 : BigUInt] {
        let interactions = try await self.getTransferEvents(for: address)
        let balances = try await self.fetchBalances(for: address, in: interactions.map{$0.contract})
        return balances.reduce(into: [ERC20: BigUInt]()) { result, current in
            let (key, value) = current
            result[key] = value
        }
    }
    
    public var rpc: URL { url }
    
    public var chain: Int { network.intValue }
        
    public func getBalance(address: EthereumAddress, block: Int?) async throws -> BigUInt {
        try await self.eth_getBalance(
            address: address,
            block: validate(block)
        )
    }
    private func validate(_ block: Int?) -> EthereumBlock {
        if let block, block > 0 {
            return .init(rawValue: block)
        } else {
            return .Latest
        }
    }

    
    public func getGasPrice() async throws -> BigUInt {
        try await self.eth_gasPrice()
    }

    
    public func estimateGas(for tx: Any) async throws -> BigUInt {
        guard let tx = tx as? EthereumTransaction else { throw EthereumClient.Error.badType }
        return try await self.eth_estimateGas(tx)
    }
    
    public func send(_ amount: BigUInt, to: EthereumAddress, from account: EthereumAccount, gasPrice: BigUInt?, gasLimit: BigUInt?) async throws -> String {

        let nonce = try await self.eth_getTransactionCount(address: account.address, block: .Latest)
        print("Nonce \(nonce)")


        let tx = EthereumTransaction(
            from: account.address,
            to: to,
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


