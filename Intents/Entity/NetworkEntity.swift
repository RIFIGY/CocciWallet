//
//  NetworkEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents


struct NetworkEntity: AppEntity {
    let id: UUID

    let title: String
    let chain: Int
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
        return Storage.shared.networks(for: wallet.id).map{
            NetworkEntity(card: $0)
        }

    }

    func entities(for identifiers: [NetworkEntity.ID]) async throws -> [NetworkEntity] {
        try await suggestedEntities().filter {
            identifiers.contains($0.id)
        }
    }
}

extension NetworkEntity {
    init(network: Network, chain: Int) {
        self.id = network.id
        self.title = network.title
        self.symbol = network.symbol
        self.chain = chain
    }
    
    init(card: NetworkCard) {
        self.init(network: card, chain: card.chain)
    }
}
