//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/24/24.
//

import Foundation
import web3
import BigInt

public struct SwapExactETHForTokens: ABIFunction {
    public static let name = "swapExactETHForTokens"
    public var contract: EthereumAddress // Uniswap Router Address
    public let from: EthereumAddress?
    
    public let amountOutMin: BigUInt
    public let path: [EthereumAddress]
    public let to: EthereumAddress
    public let deadline: BigUInt
    
    public let gasPrice: BigUInt? = nil
    public let gasLimit: BigUInt? = nil

    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                amountOutMin: BigUInt,
                path: [EthereumAddress],
                to: EthereumAddress,
                deadline: BigUInt) {
        self.contract = contract
        self.from = from
        self.amountOutMin = amountOutMin
        self.path = path
        self.to = to
        self.deadline = deadline
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(amountOutMin)
        try encoder.encode(path)
        try encoder.encode(to)
        try encoder.encode(deadline)
    }
}


extension EthereumHttpClient {
    public func swapTokensUniswap(amountOutMin: BigUInt, path: [EthereumAddress], to: EthereumAddress, deadline: BigUInt, fromAccount account: EthereumAccountProtocol) async throws -> String {
        // Encode the swap function call
        guard let data = encodeSwapFunction(amountOutMin: amountOutMin, path: path, to: to, deadline: deadline) else {
            throw EthereumClientError.encodeIssue
        }
        
        // Define the transaction
        let transaction = EthereumTransaction(
            from: nil,
            to: EthereumAddress("UniswapRouterV2Address"),
            value: BigUInt(0),
            data: data,
            nonce: nil,
            gasPrice: nil,
            gasLimit: nil,
            chainId: nil
        )
        
        do {
            let txHash = try await self.eth_sendRawTransaction(transaction, withAccount: account)
            return txHash
        } catch {
            throw error
        }
    }
    
    private func encodeSwapFunction(amountOutMin: BigUInt, path: [EthereumAddress], to: EthereumAddress, deadline: BigUInt) -> Data? {
        let uniswapRouterAddress = EthereumAddress("UniswapRouterV2Address") // Replace with actual Uniswap Router V2 address
        let swapFunction = SwapExactETHForTokens(contract: uniswapRouterAddress, amountOutMin: amountOutMin, path: path, to: to, deadline: deadline)
        
        do {
            let encoder = ABIFunctionEncoder(SwapExactETHForTokens.name)
            try swapFunction.encode(to: encoder)
            return try encoder.encoded()
        } catch {
            print("Failed to encode swap function: \(error)")
            return nil
        }
    }
}
