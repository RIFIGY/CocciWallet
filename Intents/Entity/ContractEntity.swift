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
import WalletData

//typealias ContractEntity = WalletData.ContractEntity

struct NftContractQuery: EntityQuery {
    
    @IntentParameterDependency<NFTIntent>(\.$wallet, \.$network)
    var nftIntent
    
    func suggestedEntities() async throws -> [ContractEntity] {
        []
//        guard let wallet = nftIntent?.wallet,
//              let network = nftIntent?.network else {return []}
//        let contracts = await WalletContainer.shared.fetchNFTContracts(wallet: wallet.id, networkID: network.id)
//
//        if contracts.isEmpty {
//            return []
//        } else {
//            return contracts.map { contract in
//                ContractEntity(contract: contract.contract, name: contract.name ?? contract.contract.shortened(), symbol: contract.symbol)
//            }
//        }
    }
    
    func entities(for identifiers: [ContractEntity.ID]) async throws -> [ContractEntity] {
        try await suggestedEntities().filter{ identifiers.contains($0.id) }
    }
}

struct TokenQuery: EntityQuery {
    
    @IntentParameterDependency<TokenIntent>(\.$wallet, \.$network)
    var tokenIntent
        
    func suggestedEntities() async throws -> [ContractEntity] {
        []
//        guard let wallet = tokenIntent?.wallet,
//              let network = tokenIntent?.network else {return []}
//        
//        let contracts = await WalletContainer.shared.fetchTokens(wallet: wallet.id, networkID: network.id)
//
//        if contracts.isEmpty {
//            return [ContractEntity(contract: "None", name: "none")]
//        } else {
//            return contracts.map { contract in
//                ContractEntity(contract: contract.contract, name: contract.name ?? contract.contract.shortened(), symbol: contract.symbol)
//            }
//        }
    }
    
    func entities(for identifiers: [ContractEntity.ID]) async throws -> [ContractEntity] {
        try await suggestedEntities().filter{ identifiers.contains($0.id) }
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
