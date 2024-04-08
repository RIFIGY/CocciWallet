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


public protocol EthereumClientProtocol: ERC20Client, ERC721Client {
    var rpc: URL {get}
    var chain: Int {get}
    
    associatedtype Account : Any
    func getBalance(address: String, block: Int?) async throws -> BigUInt
    func getGasPrice() async throws -> BigUInt
    func send(_ amount: BigUInt, to: String, from _: Account, gasPrice: BigUInt?, gasLimit: BigUInt?) async throws -> String
    func estimateGas(for _: Any) async throws -> BigUInt
}

open class Client<C:EthereumClientProtocol> {
    public typealias Account = C.Account
    public typealias Client = C
    public let node: Client
    public let chain: Int
    public let rpc: URL
    
    public init(client: Client, chain: Int, rpc: URL, logger: Logger? = nil) {
        self.node = client
        self.chain = chain
        self.rpc = rpc
    }
    
    public enum Error: Swift.Error {
        case badType
    }
}


public class EthereumClient: Client<EthereumHttpClient> {
    public convenience init(rpc: URL, chain: Int, logger: Logger? = nil) {
        let client = EthereumHttpClient(url: rpc, logger: logger, network: .custom(chain.description) )
        self.init(client: client, chain: chain, rpc: rpc)
    }
}


