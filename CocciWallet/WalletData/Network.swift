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
    public typealias BalanceFetch = (String, UInt8) async throws -> Double
    
    public let addressString: String
    public var card: NetworkEntity
    
    public var balance: Double?
    public var transactions: [Etherscan.Transaction]
    
    @Relationship(deleteRule: .nullify)
    public var tokens: [Token]
    
    @Relationship(deleteRule: .nullify)
    public var nfts: [NFT]
    
    public var settings: Settings
    
    @Transient
    public var lastUpdate: Date?
    
    public init(
        address: String,
        card: NetworkEntity,
        balance: Double? = nil,
        transactions: [Etherscan.Transaction] = [],
        nfts: [NFT] = [],
        tokens: [Token] = [],
        settings: Settings = .init()
    ) {
        self.addressString = address
        self.card = card
        self.balance = balance
        self.transactions = transactions
        self.nfts = nfts
        self.tokens = tokens
        self.settings = settings
    }
    
}


extension Network {
    
    public var chain: Int { card.chain}
    public var rpc: URL { card.rpc }
    public var name: String { card.name }
    public var symbol: String { card.symbol }
    public var decimals: UInt8 { card.decimals }
    public var hexColor: String { card.hexColor}

    
    public func needsUpdate() -> Bool {
        guard let lastUpdate = self.lastUpdate else { return true }
        let minutes: Double = 10
        let needsUpdate = Date().timeIntervalSince(lastUpdate) > (60 * minutes)
        print(self.name + " " + self.addressString.suffix(6) + ": \(lastUpdate.formatted(date: .omitted, time: .shortened))")
        return needsUpdate
    }
}


public extension Network {
    struct Settings: Codable {
        public var showBalance: Bool
        public var coverNFT: NFTEntity?
        public var blockList: [String]
        
        public init(showBalance: Bool = true, coverNFT: NFTEntity? = nil) {
            self.showBalance = showBalance
            self.coverNFT = coverNFT
            self.blockList = []
        }
    }
}

