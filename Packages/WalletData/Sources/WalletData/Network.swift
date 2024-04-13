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

public struct Network<N:ChainKit.BlockchainClientProtocol>: Codable {
    public typealias Address = N.Account.Address
    //    public typealias NFT = N.NFT
    public typealias EtherscanFetch = (String, String?) async throws -> [Etherscan.Transaction]
    
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
        self.address = address
        self.chain = chain
        self.name = name
        self.symbol = symbol
        self.hexColor = hexColor
        self.rpc = rpc
        self.transactions = []
        self.tokens = [:]
        self.nfts = [:]
        self.settings = .init()
    }
    
}

import SwiftUI
extension Network {
    
    
    public func fetchNFTmetadata() async {
        await withTaskGroup(of: Void.self) { group in
            self.nfts.flatMap{$0.value}.forEach { nft in
                group.addTask {
                    await nft.fetch()
                }
            }
        }
    }
    

}

private extension Network {
    
    static func fetchNFTS(for address: Address, with client: N) async -> [ Token<Address> : [NFT] ] {
        let nfts = (try? await client.fetchNFTS(for: address)) ?? [:]
        
        return nfts.reduce(into: [Token<Address> : [NFT] ]()) { partialResult, result in
            let (contract, tokens) = result
            let erc721 = tokens.compactMap{ $0 as? any ERC721Protocol }
            
            partialResult[contract] = erc721.map{ .init(nft: $0, contract: contract) }
            
        }
    }
    
    static func needsUpdate(_ card: Self) -> Bool {
//        guard !isUpdating else {return false}
        guard let lastUpdate = card.lastUpdate else { return true }
        let minutes: Double = 15
        return Date().timeIntervalSince(lastUpdate) > (60 * minutes)
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

public extension Network {
    struct Settings: Codable {
        public var showBalance = true
        public var coverNFT: BigUInt? = nil
    }
}

import Web3Kit
public typealias Web3Network = Network<EthereumClient.Client>
public extension Network where N == EthereumClient.Client {
    var decimals: UInt8 { 18 }
}
