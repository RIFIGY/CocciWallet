//
//  NftEntity.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import Web3Kit

struct NftEntity: AppEntity, Identifiable, Codable {
    var id: String { contract + "_" + tokenId }
    
    let tokenId: String
    let contract: String
    let imageUrl: URL?
    
    var contractName: String?
    var symbol: String?
    
    var metadata: OpenSeaMetadata?
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(metadata?.name ?? "#\(tokenId)")")
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "NFT"
    
    static var defaultQuery = Query()
    
}

extension NftEntity {
    struct Query: EntityQuery {
        
        @IntentParameterDependency<NFTIntent>(
            \.$wallet, \.$network, \.$contract
        )
        var intent
                
        
        func suggestedEntities() async throws -> [NftEntity] {
            guard let wallet = intent?.wallet, 
                    let network = intent?.network,
                    let contract = intent?.contract 
            else { return [] }
            
            let metadata = Storage.shared.nfts(for: contract.contract, in: network.id, owner: wallet.id)
            
            return metadata.map{
                NftEntity(nft: $0)
            }

        }

        func entities(for identifiers: [NftEntity.ID]) async throws -> [NftEntity] {
            try await suggestedEntities().filter {
                identifiers.contains($0.id)
            }
        }
    }
}
extension NftEntity {
    init(nft: NFTMetadata) {
        self.tokenId = nft.tokenId.description
        self.contract = nft.contract
        self.imageUrl = nft.imageURL
        self.contractName = nft.contractName
        self.symbol = nft.symbol
        self.metadata = nft.metadata
    }
    
}