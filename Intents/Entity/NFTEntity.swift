//
//  NftEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import Web3Kit
import OffChainKit

public struct NFTEntity: Codable, Sendable {
    public let tokenId: String
    public let contract: String
    public let uri: URL?
    public let metadata: Data?
    
    public var imageURL: URL?
    
    public init(tokenId: String, contract: String, uri: URL?, metadata: Data?, imageURL: URL? = nil) {
        self.tokenId = tokenId
        self.contract = contract
        self.uri = uri
        self.metadata = metadata
        self.imageURL = imageURL
    }

}


extension NFTEntity: Identifiable, Equatable, Hashable{
    public var id: String { tokenId + "_" + contract }
    public static func == (lhs: NFTEntity, rhs: NFTEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension NFTEntity {
    public var additional: [String:Any] {
        guard let metadata else {return [:]}
        let dict = try? JSONSerialization.jsonObject(with: metadata, options: []) as? [String:Any]
        return dict ?? [:]
    }
    public var name: String? {
        opensea?.name
    }
    
    public var gateway: URL? {
        guard let imageURL else { return nil }
        return IPFS.Gateway(imageURL)
    }
    public var opensea: OpenSeaMetadata? { try? JSONDecoder().decode(OpenSeaMetadata.self, from: metadata ?? Data()) }

}
extension NFTEntity: AppEntity {

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "#\(tokenId)")
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "NFT"
    public static var defaultQuery = Query()

    public struct Query: EntityQuery {
        
        public init(){}
        
        @MainActor
        public func suggestedEntities() throws -> [NFTEntity] {
            let nfts: [NFT] = try sharedModelContainer.mainContext.fetch(.init())
            return nfts.map{ $0.token }
        }

        @MainActor
        public func entities(for identifiers: [NFTEntity.ID]) throws -> [NFTEntity] {
            try suggestedEntities().filter {
                identifiers.contains($0.id)
            }
        }
    }
}

extension NFTEntity {
    public struct ContractQuery: EntityQuery {
        
        @IntentParameterDependency<NFTIntent>(\.$wallet, \.$network, \.$contract)
        var nftIntent
        
        public init(){}
        
        @MainActor
        public func suggestedEntities() throws -> [NFTEntity] {
            guard let wallet = nftIntent?.wallet, let network = nftIntent?.network else {return []}
            let predicate = #Predicate<Network> { item in
                wallet.address == item.addressString &&
                item.chain == network.chain
            }
            guard let networkModel = try sharedModelContainer.mainContext.fetch(.init(predicate: predicate)).first else {
                return []
            }
            
            let nfts = networkModel.nfts
            
            if let contract = nftIntent?.contract {
                return nfts.filter{$0.contract.lowercased() == contract.address.lowercased()}.map{
                    $0.token
                }
            } else {
                return nfts.map{ $0.token }
            }

        }
    }
    
    
}

public extension EntityQuery where Self.Result == [Self.Entity] {
    @MainActor
    func entities(for identifiers: [Entity.ID]) async throws -> [Self.Entity] {
        try await suggestedEntities().filter{ identifiers.contains($0.id) }
    }
}
