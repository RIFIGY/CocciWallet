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

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Wallet"

    static var defaultQuery = WalletQuery()
}

struct WalletQuery: EntityQuery {
    
    @MainActor
    func suggestedEntities() throws -> [WalletEntity] {
        let wallets:[Wallet] = try sharedModelContainer.mainContext.fetch(.init())
        return wallets.map{
            .init(name: $0.name, address: $0.string)
        }
    }

    @MainActor
    func entities(for identifiers: [WalletEntity.ID]) throws -> [WalletEntity] {
        try suggestedEntities().filter{ identifiers.contains($0.id) }
    }
}
