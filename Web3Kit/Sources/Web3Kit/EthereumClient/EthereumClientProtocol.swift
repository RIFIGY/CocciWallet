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
    func getBalance(address: String, block: Int?) async throws -> BigUInt
    func getReceipt(txHash: String) async throws -> EthereumTransactionReceipt
    func getGasPrice() async throws -> BigUInt
    func send(_ amount: BigUInt, to: String, from _: EthereumAccount, gasPrice: BigUInt?, gasLimit: BigUInt?) async throws -> String
    func estimateGas(for _: Any) async throws -> BigUInt
}

public protocol EthereumTransfer:TransactionProtocol {
    var toAddress: String {get}
    var fromAddress: String { get }
    var bigValue: BigUInt? {get}
}

public protocol ERCTransfer: EthereumTransfer, Identifiable {
    var contract: String {get}
    var log: EthereumLog {get}
}
extension ERCTransfer {
    public var logs: [EthereumLog] { [log] }
}


public protocol TransactionProtocol: Identifiable {
    associatedtype Sorter : Equatable, Comparable
    var sorter: Sorter {get}
    var title: String { get }
    var subtitle: String {get}
    var amount: Double? {get}
    var bigValue: BigUInt? {get}
    var date: Date? {get}
    
    var toAddressString: String {get}
    var fromAddressString: String {get}
}


public extension TransactionProtocol {
    var amount: Double? {nil}
    var date: Date? {nil}
}

public extension EthereumTransfer {
    var toAddressString: String { toAddress }
    var fromAddressString: String { fromAddress }
}
