//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/26/24.
//

import Foundation
import BigInt
import web3

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
extension ERCTransfer {
    public var sorter: String { log.blockNumber.stringValue }
    public var title: String {
        "Transfer"
    }
    
    public var subtitle: String {
        self.contract
    }
    
    public var id: String {
        self.log.transactionHash ??
        "\(toAddress)_\(fromAddress)_\(bigValue ?? 0)_\(contract)_\(log.data)_\(log.blockNumber.stringValue)"
    }
}


public protocol ERC721TransferProtocol: ERCTransfer {
    var tokenId: BigUInt {get}
}


public protocol TransactionProtocol: Identifiable, Hashable {
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

extension TransactionProtocol {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}


public extension TransactionProtocol {
    var amount: Double? {nil}
    var date: Date? {nil}
}

public extension EthereumTransfer {
    var toAddressString: String { toAddress }
    var fromAddressString: String { fromAddress }
}
