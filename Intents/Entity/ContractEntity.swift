//
//  NftContractEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import Web3Kit
import ChainKit


public struct ContractEntity: Codable, Sendable {
    public let address: String
    public let name: String
    public let symbol: String?
    public let decimals: UInt8?
    
    public init(address: String, name: String, symbol: String?, decimals: UInt8?) {
        self.address = address
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }
    

}

extension ContractEntity: Identifiable, Equatable, Hashable {
    public var id: String { address }

    public static func == (lhs: ContractEntity, rhs: ContractEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ContractEntity: AppEntity {
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Contract"
    
    public static var defaultQuery = Query()
    
    public struct Query: EntityQuery {
        public init(){}
        
        @MainActor
        public func suggestedEntities() throws -> [ContractEntity] {
            let tokens: [Token] = try sharedModelContainer.mainContext.fetch(.init())
            return tokens.map { $0.contract }
        }
        
        @MainActor
        public func entities(for identifiers: [ContractEntity.ID]) throws -> [ContractEntity] {
            try suggestedEntities().filter{
                identifiers.contains($0.id)
            }
        }
    }
}

extension ContractEntity {
    
    struct NFTQuery: EntityQuery {
        
        @IntentParameterDependency<NFTIntent>(\.$wallet, \.$network)
        var nftIntent
        
        @MainActor
        func suggestedEntities() throws -> [ContractEntity] {
            guard let wallet = nftIntent?.wallet, let network = nftIntent?.network else {return []}
            
            let predicate = #Predicate<Network> { item in
                wallet.address == item.addressString &&
                item.chain == network.chain
            }
            guard let networkModel = try sharedModelContainer.mainContext.fetch(.init(predicate: predicate)).first else {
                return []
            }
            
            return networkModel.nfts.map{ .init(address: $0.contract, name: "", symbol: nil, decimals: nil) }
        }
        
        @MainActor
        func entities(for identifiers: [ContractEntity.ID]) throws -> [ContractEntity] {
            try suggestedEntities().filter{ identifiers.contains($0.id) }
        }
    }
}

extension ContractEntity {
    
    struct TokenQuery: EntityQuery {
        
        @IntentParameterDependency<TokenIntent>(\.$wallet, \.$network)
        var tokenIntent
        
        @MainActor
        func suggestedEntities() throws -> [ContractEntity] {
            guard let wallet = tokenIntent?.wallet, let network = tokenIntent?.network else {return []}
            
            let predicate = #Predicate<Network> { item in
                wallet.address == item.addressString &&
                item.chain == network.chain
            }
            guard let networkModel = try sharedModelContainer.mainContext.fetch(.init(predicate: predicate)).first else {
                return []
            }
            
            return networkModel.tokens.map{ $0.contract }
            
        }
        
    }
}
//
//extension ContractEntity {
//    init(contract: any Contract) {
//        self.contract = contract.contract.string
//        self.name = contract.title
//        self.symbol = contract.symbol
//    }
//}
