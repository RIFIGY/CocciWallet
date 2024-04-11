//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/26/24.
//

import Foundation
import BigInt
import web3
import ChainKit

public protocol EthereumTransfer:TransactionProtocol where Address == web3.EthereumAddress {
    var to: web3.EthereumAddress {get}
    var from: web3.EthereumAddress { get }
    var bigValue: BigUInt? {get}
}

public protocol ERCTransfer: EthereumTransfer, Identifiable {
    var contract: web3.EthereumAddress {get}
    var log: EthereumLog {get}
}


extension ERCTransfer {
    public var sorter: String { self.log.blockNumber.stringValue }
    public var logs: [EthereumLog] { [log] }
    public var contract: web3.EthereumAddress { self.log.address }
    
    public var title: String {
        "Transfer"
    }
    
    public var subtitle: String {
        self.contract.string
    }
    
    public var id: String {
        self.log.transactionHash ??
        "\(to.string)_\(from.string)_\(bigValue ?? 0)_\(contract)_\(log.data)_\(log.blockNumber.stringValue)"
    }
    
    public var timestamp: Date? {
        nil
    }
    
}


public protocol ERC721TransferProtocol: ERCTransfer {
    var tokenId: BigUInt {get}
}
extension ERC721TransferProtocol {
    public var bigValue: BigUInt? { nil }
}
