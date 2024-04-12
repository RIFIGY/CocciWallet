//
//  NFTMetadata.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import Foundation
import Web3Kit
import BigInt
import OffChainKit
import ChainKit

@Observable
public class NFT: Codable {
    
    public let tokenId: BigUInt
    public let contract: String
    public let contractName: String?
    public let symbol: String?
    public let uri: URL?
    private var json: Data?

    public var imageURL: URL?
    public private(set) var image: PlatformImage?
    public private(set) var metadata: OpenSeaMetadata?
    
    public var additional: [String:Any] {
        guard let json else  {return [:]}
        let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String:Any]
        return dict ?? [:]
    }
    
    public init<N:ChainKit.ERC721Protocol>(nft: N, contract: any Contract, json: Data? = nil) {
        self.tokenId = nft.tokenId
        self.uri = nft.uri
        self.contract = contract.contract.string
        self.contractName = contract.name
        self.symbol = contract.symbol
        self.json = json
        try? decodeMetadata()
    }
    
    public init(tokenId: BigUInt, contract: String, contractName: String?, symbol: String?, uri: URL?, json: Data? = nil) {
        self.tokenId = tokenId
        self.contract = contract
        self.contractName = contractName
        self.symbol = symbol
        self.uri = uri
        self.json = json
        try? decodeMetadata()
    }

    public func fetch() async {
        do {
            try await fetchJSON()
            try decodeMetadata()
//            try await fetchImage()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func fetchJSON() async throws {
        guard let uri, json == nil else {return}
        let gateway = IPFS.Gateway(uri)
        let (data, _) = try await URLSession.shared.data(from: gateway)
        self.json = data
    }
    
    private func decodeMetadata() throws {
        guard let json else {return}
        let metadata = try JSONDecoder().decode(OpenSeaMetadata.self, from: json)
        self.metadata = metadata
        if let image = metadata.image, let url = URL(string: image) {
            self.imageURL = url
        }
    }
    
    
    private func fetchImage() async throws {
        guard let url = imageURL else {return}
        
        let gateway = IPFS.Gateway(url)
        let (data, _) = try await URLSession.shared.data(from: gateway)
        self.image = PlatformImage(data: data)
    }
    
}

extension NFT: Identifiable, Equatable, Hashable{
    public static func == (lhs: NFT, rhs: NFT) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
public extension NFT {
    enum CodingKeys: String, CodingKey {
        case tokenId, contract, contractName, symbol, uri
        case _json = "json"
        case _imageURL = "imageURL"
    }
}
