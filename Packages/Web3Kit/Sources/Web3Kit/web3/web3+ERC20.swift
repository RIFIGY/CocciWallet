//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import web3
import BigInt
import ChainKit

public typealias ERC20 = Token<web3.EthereumAddress>
extension EthereumHttpClient: ERC20Client {
    private var erc20: web3.ERC20 { .init(client: self) }
    
    public func getBalance(contract: EthereumAddress, address: EthereumAddress) async throws -> BigUInt {
        try await erc20.balanceOf(
            tokenContract: contract,
            address: contract
        )
    }
    
    public func getContract(address contract: EthereumAddress) async throws -> ERC20 {

        async let name: String? = try? await erc20.name(tokenContract: contract)
        async let symbol: String? = try? await erc20.symbol(tokenContract: contract)
        async let decimals: UInt8 = try await erc20.decimals(tokenContract: contract)

        return try await ERC20(
            contract: contract,
            name: name ?? "",
            symbol: symbol ?? "",
            decimals: decimals)
    }
    
    public func getTransferEvents(for address: EthereumAddress) async throws -> [ERC20Transfer] {
                
        async let from = try await self.erc20.transferEventsFrom(sender: address, fromBlock: .Earliest, toBlock: .Latest)
        async let to = try await self.erc20.transferEventsTo(recipient: address, fromBlock: .Earliest, toBlock: .Latest)

        return try await (from + to).sorted{$0.log.blockNumber < $1.log.blockNumber}
        
    }
}

extension ERC20Events.Transfer: ERCTransfer {
    public var bigValue: BigUInt? { value }
}
public typealias ERC20Transfer = ERC20Events.Transfer

public extension ERC20 {
    static let USDC = ERC20(contract: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", name: "USD Coin", symbol: "USDC", decimals: 6)
}
