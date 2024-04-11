//
//  File.swift
//  
//
//  Created by Michael on 4/10/24.
//

import SwiftData
import ChainKit
import Web3Kit

@Model
public class PrivateKeyWallet {
    public typealias Client = EthereumClient.Client
    public typealias Address = Client.Account.Address
    
    @Attribute(.unique)
    public var id: String
    public var name: String
    
    public var settings: Settings
    public var networks: [WalletData.Network<Client>]
    
    public var type: Kind

    public init(address: Address, name: String, type: Kind = .watch) {
        self.id = address.string
        self.type = type
        self.name = name
        self.networks = []
        self.settings = .init()
    }
    
    /// UUID generated from seed, not seed itself
    public init(seedID: String, name: String, type: Kind = .watch) {
        self.id = seedID
        self.type = type
        self.name = name
        self.networks = []
        self.settings = .init()
    }
    
    public var address: Address { .init(id) }

}


public extension PrivateKeyWallet {
    var hasKey: Bool {
        type != .watch
    }
    struct Settings: Codable {
        public var displayAsCards = true
        public var groupTokens = true
    }
    
    enum Kind: String, CaseIterable, Identifiable, Hashable, Codable {
        public var id: String { rawValue }
        case watch, key, seed
    }

}

public typealias Web3Wallet = PrivateKeyWallet
public typealias SolanaWallet = PrivateKeyWallet
