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

extension EthereumHttpClient: ERC20Client {
    
    private var erc20: web3.ERC20 { .init(client: self) }
    
    public func getBalance(contract: String, address: String) async throws -> BigUInt {
        try await erc20.balanceOf(
            tokenContract: try validate(contract),
            address: try validate(address)
        )
    }
    
    public func getContract(address contract: String) async throws -> ChainKit.ERC20 {
        let validatedContract = try validate(contract)

        async let name: String? = try? await erc20.name(tokenContract: validatedContract)
        async let symbol: String? = try? await erc20.symbol(tokenContract: validatedContract)
        async let decimals: UInt8 = try await erc20.decimals(tokenContract: validatedContract)

        return try await ERC20(contract: .init(contract), name: name ?? "", symbol: symbol ?? "", decimals: decimals)
    }
    
    public func getTransferEvents(for address: String) async throws -> [ERC20Transfer] {
        
        let address = try validate(address)
        
        async let from = try await self.erc20.transferEventsFrom(sender: address, fromBlock: .Earliest, toBlock: .Latest)
        async let to = try await self.erc20.transferEventsTo(recipient: address, fromBlock: .Earliest, toBlock: .Latest)

        return try await (from + to)
        
    }
}

public typealias ERC20Transfer = ERC20Events.Transfer

extension ERC20Transfer: ERCTransfer {
    public var contract: String { log.address.asString() }
    public var toAddress: String { to.asString() }
    public var fromAddress: String { from.asString() }
    public var bigValue: BigUInt? { value }

}
extension ERC20Transfer: TransactionProtocol {
    public var timestamp: Date? {
        nil
    }
    

}
