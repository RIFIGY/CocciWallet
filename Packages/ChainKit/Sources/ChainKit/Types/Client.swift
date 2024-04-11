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
    associatedtype Metadata : Codable
    associatedtype NFT : ChainKit.NFTProtocol
    func fetchBalance(for address: Account.Address) async throws -> BigUInt
    func ping() async throws -> Bool
    
    func fetchTokens(for address: Account.Address) async throws -> [ Token<Account.Address> : BigUInt]
    func fetchNFTS(for address: Account.Address) async throws -> [ Token<Account.Address> : [NFT] ]
}

//extension BlockchainClientProtocol {
//    public func fetchTokens(for address: Account.Address) async throws -> [ Token<Account.Address> : BigUInt] {
//        [:]
//    }
//    public func fetchNFTS(for address: Account.Address) async throws -> [ Token<Account.Address> : [NFT] ] {
//        [:]
//    }
//}


public protocol EthereumClientProtocol: BlockchainClientProtocol {
    var rpc: URL {get}
    var chain: Int {get}
    func fetchGasPrice() async throws -> BigUInt
}
