//
//  WalletEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents

struct WalletEntity: AppEntity, Identifiable, Codable {
    var id: String { address }

    var name: String
    let address: String
//    var cards: [NetworkEntity] = []
//    var custom: [NetworkEntity] = []

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Wallet"

    static var defaultQuery = WalletQuery()
    
    enum CodingKeys: String, CodingKey {
        case address
        case name = "_name"
    }
}

struct WalletQuery: EntityQuery {
    
    func suggestedEntities() async throws -> [WalletEntity] {
        Storage.shared.wallets()
    }

    func entities(for identifiers: [WalletEntity.ID]) async throws -> [WalletEntity] {
        try await suggestedEntities().filter{ identifiers.contains($0.id) }
    }
}