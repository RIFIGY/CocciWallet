//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt
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
