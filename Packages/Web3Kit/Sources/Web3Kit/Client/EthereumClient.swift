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
import ChainKit

public protocol EthereumClientProtocol: ChainKit.EthereumClientProtocol, ERC20Client, ERC721Client where Account == EthereumAccount {
    var rpc: URL {get}
    var chain: Int {get}
    
    func getBalance(address: Account.Address, block: Int?) async throws -> BigUInt
    func getGasPrice() async throws -> BigUInt
    func send(_ amount: BigUInt, to: Account.Address, from _: Account, gasPrice: BigUInt?, gasLimit: BigUInt?) async throws -> String
    func estimateGas(for _: Any) async throws -> BigUInt
}
extension EthereumClientProtocol {
    
    
    public func fetchBalance(for address: web3.EthereumAddress) async throws -> BigUInt {
        try await getBalance(address: address, block: nil)
    }
    
    public func ping() async throws -> Bool {
        let _ = try await getGasPrice()
        return true
    }
    public func fetchGasPrice() async throws -> BigUInt {
        try await getGasPrice()
    }


}



open class Client<Client:EthereumClientProtocol> {
    public typealias Account = Client.Account
    public typealias Address = Client.Account.Address
    public typealias Client = Client
    public typealias Metadata = Client.Metadata
    public let node: Client
    public let chain: Int
    public let rpc: URL
    
    public init(client: Client, chain: Int, rpc: URL) {
        self.node = client
        self.chain = chain
        self.rpc = rpc
    }
    
    public enum Error: Swift.Error {
        case badType
    }
}


public class EthereumClient: Client<EthereumHttpClient> {
    public convenience init(
        rpc: URL,
        chain: Int,
        logger: Logger? = nil
    ) {
        let client = EthereumHttpClient(
            url: rpc,
            logger: logger,
            network: .custom(chain.description)
        )
        self.init(client: client, chain: chain, rpc: rpc)
    }
}


