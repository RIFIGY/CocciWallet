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

struct ContractEntity: AppEntity, Identifiable, Codable {
    var id: String { contract }
    
    let contract: String
    let name: String
    
    var symbol: String?
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Contract"
    
    static var defaultQuery = NftContractQuery()
}


struct NftContractQuery: EntityQuery {
    
    @IntentParameterDependency<NFTIntent>(\.$wallet, \.$network)
    var nftIntent
    
    func suggestedEntities() async throws -> [ContractEntity] {
        guard let wallet = nftIntent?.wallet,
              let network = nftIntent?.network else {return []}
        let contracts = Storage.shared.nftContracts(for: wallet.id, in: network)

        if contracts.isEmpty {
            return [ContractEntity(contract: "None", name: "none")]
        } else {
            return contracts.map { contract in
                ContractEntity(contract: contract)
            }
        }
    }
    
    func entities(for identifiers: [ContractEntity.ID]) async throws -> [ContractEntity] {
        try await suggestedEntities().filter{ identifiers.contains($0.id) }
    }
}

struct TokenQuery: EntityQuery {
    
    @IntentParameterDependency<TokenIntent>(\.$wallet, \.$network)
    var tokenIntent
        
    func suggestedEntities() async throws -> [ContractEntity] {
        guard let wallet = tokenIntent?.wallet,
              let network = tokenIntent?.network else {return []}
        let contracts = Storage.shared.tokenContracts(for: wallet.id, in: network.id)

        if contracts.isEmpty {
            return [ContractEntity(contract: "None", name: "none")]
        } else {
            return contracts.map { contract in
                ContractEntity(contract: contract)
            }
        }
    }
    
    func entities(for identifiers: [ContractEntity.ID]) async throws -> [ContractEntity] {
        try await suggestedEntities().filter{ identifiers.contains($0.id) }
    }
    
}

extension ContractEntity {
    init(contract: any Contract) {
        self.contract = contract.contract.string
        self.name = contract.title
        self.symbol = contract.symbol
    }
}
