//
//  NFTMetadata.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import Foundation
import OffChainKit

public typealias NFT = NFTEntity
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

}
