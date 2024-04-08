//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation
import BigInt

public protocol BlockchainClientProtocol {
    associatedtype Account : ChainKit.AccountProtocol
    associatedtype Address : ChainKit.Address
    func fetchBalance(for address: Address) async throws -> BigUInt
    func ping() async throws -> Bool
}


public protocol EthereumClientProtocol: BlockchainClientProtocol where Account == EthereumAccount<EthereumAddress>, Address == EthereumAddress {
    func fetchGasPrice() async throws -> BigUInt
}
