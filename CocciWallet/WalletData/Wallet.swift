//
//  File.swift
//
//
//  Created by Michael on 4/10/24.
//

import SwiftData
import SwiftUI

public typealias Wallet = PrivateKeyWallet

@Model
public class PrivateKeyWallet {
    
    @Attribute(.unique)
    public var string: String
    public var name: String
    
    public var settings: Settings
    
    @Relationship(deleteRule: .nullify)
    public var networks: [Network]
    
    public var type: Kind

    public init(address: String, name: String, type: Kind = .watch) {
        self.string = address
        self.type = type
        self.name = name
        self.networks = []
        self.settings = .init()
    }
    
    /// UUID generated from seed, not seed itself
    public init(seedID: String, name: String, type: Kind = .watch) {
        self.string = seedID
        self.type = type
        self.name = name
        self.networks = []
        self.settings = .init()
    }
    
//    @Transient
//    public var selected: Network? = nil
}


public extension PrivateKeyWallet {
    var hasKey: Bool {
        type != .watch
    }
    
}

public extension PrivateKeyWallet {
    struct Settings: Codable {
        public var displayAsCards = true
        public var groupTokens = true
        public init(displayAsCards: Bool = true, groupTokens: Bool = true) {
            self.displayAsCards = displayAsCards
            self.groupTokens = groupTokens
        }
    }
    
    enum Kind: String, CaseIterable, Identifiable, Hashable, Codable {
        public var id: String { rawValue }
        case watch, key, seed
        public var systemImage: String {
            switch self {
            case .watch:
                "magnifyingglass"
            case .key:
                "key"
            case .seed:
                "list.number"
            }
        }
        
        public var color: Color {
            switch self {
            case .watch:
                .blue
            case .key:
                .orange
            case .seed:
                .indigo
            }
        }
    }

}


// MARK: - SeedWallet

@Model
public class SeedWallet {
    
    @Attribute(.unique)
    public var id: UUID
    public var name: String
    
    public var settings: Settings
    
    public var web3: PrivateKeyWallet?
    public var solana: PrivateKeyWallet?

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
