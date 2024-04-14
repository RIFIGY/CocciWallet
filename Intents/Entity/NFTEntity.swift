//
//  NftEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import Web3Kit

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
    
        public var name: String? { opensea?.name }
        public var opensea: OpenSeaMetadata? { try? JSONDecoder().decode(OpenSeaMetadata.self, from: metadata ?? Data()) }
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

}
extension NFTEntity: AppEntity {

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "#\(tokenId)")
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "NFT"
    public static var defaultQuery = AllNFTQuery()

}

extension NFTEntity {
    public struct AllNFTQuery: EntityQuery {
        
        public init(){}
        
        public func suggestedEntities() async throws -> [NFTEntity] {
            await WalletContainer.shared.fetchAllNFTs()
        }

        public func entities(for identifiers: [NFTEntity.ID]) async throws -> [NFTEntity] {
            try await suggestedEntities().filter {
                identifiers.contains($0.id)
            }
        }
    }
}
