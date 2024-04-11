//
//  File.swift
//  
//
//  Created by Michael on 4/10/24.
//

import Foundation
import SwiftData
import ChainKit
import BigInt
import OffChainKit

@Observable
public class Network<N:ChainKit.BlockchainClientProtocol>: Codable {
    public typealias Address = N.Account.Address
    public typealias NFT = N.NFT
    public let address: Address
    public var chain: Int
    public var rpc: URL
    public var name: String
    public var symbol: String
    public var balance: BigUInt?
    public var hexColor: String
    public var transactions: [Etherscan.Transaction]
    
    public var nfts: [Token<Address> : [NFT] ]
    public var tokens: [Token<Address> : BigUInt ]
    
    
    public var settings: Settings
    public var lastUpdate: Date?
    
    public init(address: Address, chain: Int, rpc: URL, name: String, symbol: String, hexColor: String) {
        self.chain = chain
        self.name = name
        self.symbol = symbol
        self.address = address
        self.hexColor = hexColor
        self.rpc = rpc
        self.transactions = []
        self.tokens = [:]
        self.nfts = [:]
        self.settings = .init()
    }
    
    
    @Transient var isUpdating = false
    
    public func update(with client: N) async -> Bool {
        guard !isUpdating else {return false}
        print("Updating \(name)")

        isUpdating = true
        await withTaskGroup(of: Void.self) { group in
            
            group.addTask {
                self.balance = try? await client.fetchBalance(for: self.address)
            }
            group.addTask {
                self.tokens = (try? await client.fetchTokens(for: self.address)) ?? [:]
            }
            group.addTask {
                self.nfts = (try? await client.fetchNFTS(for: self.address)) ?? [:]
            }
        }
        isUpdating = false
        print("Balance:\(balance) TX: \(self.transactions.count) Tokens: \(self.tokens.keys.count) NFT: \(self.nfts.keys.count)")
        return true
    }

}
public extension Network {
    struct Settings: Codable {
        public var showBalance = true
        public var coverNFT: BigUInt? = nil
    }
}

extension Network: Identifiable, Hashable, Equatable, Comparable {
    public var id: String { chain.description + "_" + address.string }

    public static func == (lhs: Network, rhs: Network) -> Bool {
        lhs.id == rhs.id
    }
    
    public static func < (lhs: Network, rhs: Network) -> Bool {
        lhs.chain < rhs.chain
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
}

import Web3Kit
public typealias Web3Network = Network<EthereumClient.Client>

public extension Network where N == EthereumClient.Client {
    var decimals: UInt8 { 18 }
}
