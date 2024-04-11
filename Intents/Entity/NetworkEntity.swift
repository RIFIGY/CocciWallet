//
//  NetworkEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import WalletData

struct NetworkEntity: AppEntity {
    let id: String

    let title: String
    let symbol: String?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Network"

    static var defaultQuery = NetworkQuery()
    
}

struct NetworkQuery: EntityQuery {
    
    @IntentParameterDependency<NFTIntent>(
        \.$wallet
    )
    var nftIntent
    
    @IntentParameterDependency<TokenIntent>(
        \.$wallet
    )
    var tokenIntent
    
    private var wallet: WalletEntity? {
        nftIntent?.wallet ?? tokenIntent?.wallet
    }
        
    func suggestedEntities() async throws -> [NetworkEntity] {
        guard let wallet else {return []}
        return try await WalletContainer.shared.fetchNetworks(wallet: wallet.id).map{
            NetworkEntity(network: $0)
        }

    }

    func entities(for identifiers: [NetworkEntity.ID]) async throws -> [NetworkEntity] {
        try await suggestedEntities().filter {
            identifiers.contains($0.id)
        }
    }
}

extension NetworkEntity {
    init(network: Web3Network) {
        self.id = network.id
        self.title = network.name
        self.symbol = network.symbol
    }
}
