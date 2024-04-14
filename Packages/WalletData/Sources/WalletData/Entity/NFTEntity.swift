//
//  NFTMetadata.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import Foundation
import OffChainKit
import AppIntents

public typealias NFT = NFTEntity
public struct NFTEntity: Codable, AppEntity {
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
    

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "#\(tokenId)")
    }
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "NFT"
    public static var defaultQuery = AllNFTQuery()

}

extension NFTEntity: Identifiable, Equatable, Hashable{

    
    public var id: String { tokenId + "_" + contract }
    public static func == (lhs: NFT, rhs: NFT) -> Bool {
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

public extension NFTEntity {
    struct AllNFTQuery: EntityQuery {
        
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

//
//@Observable
//public class NFT: Codable {
//    
//    public let entity: NFTEntity
//    
//    private var json: Data?
//    public var imageURL: URL?
//    public private(set) var image: PlatformImage?
//    public private(set) var metadata: OpenSeaMetadata?
//    
//    public var additional: [String:Any] {
//        guard let json else  {return [:]}
//        let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String:Any]
//        return dict ?? [:]
//    }
//    
//
//    public init(tokenId: String, contract: Token, uri: URL?, json: Data? = nil) {
//        self.tokenId = tokenId
//        self.contract = contract
//        self.uri = uri
//        self.json = json
//        try? decodeMetadata()
//    }
//    
//    public init(tokenId: String, contract: String, contractName: String?, symbol: String?, uri: URL?, json: Data? = nil) {
//        self.tokenId = tokenId
//        self.contract = .init(address: contract, name: contractName ?? contract, symbol: symbol, decimals: nil)
//        self.uri = uri
//        self.json = json
//        try? decodeMetadata()
//    }
//}

//extension NFT {
//
//    public func fetch() async {
//        do {
//            try await fetchJSON()
//            try decodeMetadata()
////            try await fetchImage()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    
//    private func fetchJSON() async throws {
//        guard let uri, json == nil else {return}
//        let gateway = IPFS.Gateway(uri)
//        let (data, _) = try await URLSession.shared.data(from: gateway)
//        self.json = data
//    }
//    
//    private func decodeMetadata() throws {
//        guard let json else {return}
//        let metadata = try JSONDecoder().decode(OpenSeaMetadata.self, from: json)
//        self.metadata = metadata
//        if let image = metadata.image, let url = URL(string: image) {
//            self.imageURL = url
//        }
//    }
//    
//    
//    private func fetchImage() async throws {
//        guard let url = imageURL else {return}
//        
//        let gateway = IPFS.Gateway(url)
//        let (data, _) = try await URLSession.shared.data(from: gateway)
//        self.image = PlatformImage(data: data)
//    }
//    
//}
//
//extension NFT: Identifiable, Equatable, Hashable{
//    public static func == (lhs: NFT, rhs: NFT) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//public extension NFT {
//    enum CodingKeys: String, CodingKey {
//        case tokenId, contract, uri
//        case _json = "json"
//        case _imageURL = "imageURL"
//    }
//}
//
