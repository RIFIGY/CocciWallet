//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import web3
import BigInt

extension EthereumHttpClient: ERC20Client {
    internal var erc20: web3.ERC20 { .init(client: self) }
    
    public func getERC20Contract(for contract: String) async throws -> ERC20 {
        let validatedContract = try validate(contract)

        // Concurrently fetch the name, symbol, and decimals using async let bindings
        async let name: String? = try? await erc20.name(tokenContract: validatedContract)
        async let symbol: String? = try? await erc20.symbol(tokenContract: validatedContract)
        async let decimals: UInt8 = try await erc20.decimals(tokenContract: validatedContract)

        // Await the results of the concurrent operations
        let fetchedName = await name
        let fetchedSymbol = await symbol
        let fetchedDecimals = try await decimals // Handle errors specifically for decimals as it's non-optional

        // Initialize and return the ERC20 struct
        return ERC20(contract: contract, name: fetchedName, symbol: fetchedSymbol, decimals: fetchedDecimals)
    }


    public func getERC20balance(contract: String, address: String) async throws -> BigUInt {
        try await erc20.balanceOf(
            tokenContract: try validate(contract),
            address: try validate(address)
        )
    }
    
    public func getERC20events(for address: String) async throws -> [ERC20Transfer] {
        
        let address = try validate(address)

        
        return try await withThrowingTaskGroup(of: [ERC20Events.Transfer].self, returning: [ERC20Events.Transfer].self) { taskGroup in
            taskGroup.addTask {
                try await self.erc20.transferEventsFrom(sender: address, fromBlock: .Earliest, toBlock: .Latest)
            }
            taskGroup.addTask {
                try await self.erc20.transferEventsTo(recipient: address, fromBlock: .Earliest, toBlock: .Latest)
            }
            
            return try await taskGroup.reduce(into: [ERC20Events.Transfer]()) { partialResult, events in
                partialResult.append(contentsOf: events)
            }
        }
    }
}
public typealias ERC20Transfer = ERC20Events.Transfer


extension ERC20Events.Transfer: ERCTransfer {
    public var sorter: String { self.log.blockNumber.stringValue }
    public var title: String {
        "Transfer"
    }
    
    public var subtitle: String {
        self.contract
    }
    
    public var id: String {
        self.log.transactionHash ??
        "\(toAddress)_\(fromAddress)_\(value)_\(contract)_\(log.data)_\(log.blockNumber.stringValue)"
    }
    
    public var toAddress: String { self.to.asString() }
    public var fromAddress: String { self.from.asString() }
    public var bigValue: BigUInt? { self.value }
    public var contract: String { self.log.address.asString() }
    
}

