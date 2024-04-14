//
//  File.swift
//  
//
//  Created by Michael on 4/10/24.
//

import Foundation
import SwiftData
import OffChainKit

@Model
public class Network {
    public typealias EtherscanFetch = (String, String?) async throws -> [Etherscan.Transaction]
    
    public let wallet: PrivateKeyWallet
    public var chain: Int
    public var rpc: URL
    public var name: String
    public var symbol: String
    public var decimals: UInt8
    public var balance: Double?
    public var hexColor: String
    public var transactions: [Etherscan.Transaction]
    
    public var nfts: [NFT]
    public var tokens: [Token]
    
    
    public var settings: Settings
    public var lastUpdate: Date?
    
    public init(wallet: PrivateKeyWallet, chain: Int, rpc: URL, name: String, symbol: String, decimals: UInt8 = 18, hexColor: String) {
        self.wallet = wallet
        self.chain = chain
        self.rpc = rpc
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.hexColor = hexColor
        
        self.transactions = []
        self.tokens = []
        self.nfts = []
        self.settings = .init()
    }
}



extension Network {
    
    public func needsUpdate() -> Bool {
        guard let lastUpdate = self.lastUpdate else { return true }
        let minutes: Double = 1
        return Date().timeIntervalSince(lastUpdate) > (60 * minutes)
    }
}



extension Network: Identifiable, Hashable, Equatable, Comparable {
    public var id: String { chain.description + "_" + wallet.id }

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
        public var coverNFT: String? = nil
    }
}

