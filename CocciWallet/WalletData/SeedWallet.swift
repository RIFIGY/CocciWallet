//
//  File.swift
//  
//
//  Created by Michael on 4/10/24.
//

import Foundation
import SwiftData

@Model
public class SeedWallet {
    
    @Attribute(.unique)
    public var id: UUID
    public var name: String
    
    public var settings: Settings
    
    public var web3: Web3Wallet?
    public var solana: SolanaWallet?

    public init(name: String) {
        self.id = UUID()
        self.name = name
        self.settings = .init()
    }
}
public extension SeedWallet {
    struct Settings: Codable {
        public var displayAsCards = true
        public var groupTokens = true
    }
}

