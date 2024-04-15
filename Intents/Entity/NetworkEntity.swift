//
//  NetworkEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents

public struct NetworkEntity: Codable {
    
    public var chain: Int
    public var rpc: URL
    
    public var name: String
    public var hexColor: String

    public var coin: String
    public var symbol: String
    public var decimals: UInt8
    public var explorer: String
    
    public var title: String { name }

    public init(chain: Int, rpc: URL, name: String, hexColor: String, coin: String, symbol: String, decimals: UInt8, explorer: String = "") {
        self.chain = chain
        self.rpc = rpc
        self.name = name
        self.hexColor = hexColor
        self.coin = coin
        self.symbol = symbol
        self.decimals = decimals
        self.explorer = explorer
    }
}

extension NetworkEntity: Identifiable {
    public var id: Int {chain}
}

extension NetworkEntity: AppEntity {
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Network"

    public static var defaultQuery = Query()
    
    public struct Query: EntityQuery {
        public init(){}
        
        @MainActor
        public func suggestedEntities() throws -> [NetworkEntity] {
            let networks: [Network] = try sharedModelContainer.mainContext.fetch(.init())
            return networks.map { $0.card }
        }
        
        @MainActor
        public func entities(for identifiers: [NetworkEntity.ID]) throws -> [NetworkEntity] {
            try suggestedEntities().filter {
                identifiers.contains($0.id)
            }
        }
    }
}

extension NetworkEntity {
    
    public struct WalletQuery: EntityQuery {
        
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
        public init(){}
        
        @MainActor
        public func suggestedEntities() throws -> [NetworkEntity] {
            guard let wallet else {return []}
            let predicate = #Predicate<Network> { network in
                network.addressString == wallet.address
            }
            return try sharedModelContainer.mainContext.fetch(.init(predicate: predicate)).map{
                $0.card
            }
            
        }
        
        @MainActor
        public func entities(for identifiers: [NetworkEntity.ID]) throws -> [NetworkEntity] {
            try suggestedEntities().filter {
                identifiers.contains($0.id)
            }
        }
    }
    
}
