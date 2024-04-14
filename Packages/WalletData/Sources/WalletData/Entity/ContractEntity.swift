//
//  File.swift
//  
//
//  Created by Michael on 4/13/24.
//

import Foundation
import AppIntents

public struct ContractEntity: Codable, AppEntity {
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
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Contract"
    
    public static var defaultQuery = AllContractsQuery()
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


public extension ContractEntity {
    struct AllContractsQuery: EntityQuery {
        public init(){}
        
        public func suggestedEntities() async throws -> [ContractEntity] {
            await WalletContainer.shared.fetchAllContracts()
        }
        
        public func entities(for identifiers: [ContractEntity.ID]) async throws -> [ContractEntity] {
            try await suggestedEntities().filter{
                identifiers.contains($0.id)
            }
        }
    }
}
