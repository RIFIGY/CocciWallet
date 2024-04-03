//
//  WalletModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation

@Observable
class Wallet: Codable {
    let address: String
    let blockHD: String

    var name: String
    private(set) var type: WalletKey
    var cards: [NetworkCard] = []
    var custom: [NetworkCard] = []
    var settings: Settings

    init(address: String, name: String, type: WalletKey, blockHD: String, settings: Settings = Settings()) {
        self.address = address
        self.name = name
        self.type = type
        self.blockHD = blockHD
        self.settings = settings
    }
}

extension Wallet {
    struct Settings: Codable {
        var displayAsCards = true
        var groupTokens = true
    }
}

extension Wallet {
    func add(_ card: NetworkCard) {
        let isCustom = card.isCustom
        
        isCustom ? custom.append(card) : cards.append(card)
        
        save()
    }
    
    func remove(_ card: NetworkCard) {
        let isCustom = card.isCustom
        
        isCustom ? custom.remove(card) : cards.remove(card)
        
        save()
    }
    
    func save() {
        Storage.shared.setCodable(self, forKey: address)
        print("Saved \(name)")
    }
}

extension Wallet: Identifiable, Equatable, Hashable {
    var id: String { address }

    static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

import SwiftUI
enum WalletKey: String, CaseIterable, Identifiable, Codable {
    
    case watch, privateKey, mnemonic
    
    var id: String { rawValue }
    var systemImage: String {
        switch self {
        case .watch:
            "magnifyingglass"
        case .privateKey:
            "key"
        case .mnemonic:
            "list.bullet.rectangle"
        }
    }
    
    var color: Color {
        switch self {
        case .watch:
            Color.blue
        case .privateKey:
            Color.purple
        case .mnemonic:
            Color.orange
        }
    }
    
}
