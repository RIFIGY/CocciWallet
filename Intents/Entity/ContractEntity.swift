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
    
    public static var defaultQuery = AllContractsQuery()
    
    public struct AllContractsQuery: EntityQuery {
        public init(){}
        
        public func suggestedEntities() async throws -> [ContractEntity] {
            await WalletContainer.shared.fetchAllContracts().map{
                .init(address: $0.address, name: $0.name, symbol: $0.symbol, decimals: $0.decimals)
            }
        }
        
        public func entities(for identifiers: [ContractEntity.ID]) async throws -> [ContractEntity] {
            try await suggestedEntities().filter{
                identifiers.contains($0.id)
            }
        }
    }
}

struct NftContractQuery: EntityQuery {
    
//    @IntentParameterDependency<NFTIntent>(\.$wallet, \.$network)
//    var nftIntent
    
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
    
//    @IntentParameterDependency<TokenIntent>(\.$wallet, \.$network)
//    var tokenIntent
        
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
