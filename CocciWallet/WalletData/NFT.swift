//
//  NFT.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import Foundation
import SwiftData
import Web3Kit

@Model
public class NFT {
//    public let network: Network
    public let token: NFTEntity
    
    init(token: NFTEntity) {
        self.token = token
//        self.json = token.metadata
//        self.imageURL = token.imageURL
//        decodeMetadata(for: token.metadata)
    }
    
//    private func decodeMetadata(for json: Data?) {
//        guard let json else {return}
//        let opensea = try? JSONDecoder().decode(OpenSeaMetadata.self, from: json)
//    }
    
//    public func decodeMetadata() {
//        decodeMetadata(for: token.metadata ?? self.json)
//    }
    
//    @Transient
//    public var imageURL: URL?
//    
//    @Transient
//    public var json: Data?
//    
//    @Transient
//    public var opensea: OpenSeaMetadata?
}


extension NFT {
    public var title: String { token.opensea?.name ?? "#\(token.tokenId)" }
    public var opensea: OpenSeaMetadata? { token.opensea }
    public var tokenId: String { token.tokenId }
    public var contract: String { token.contract }
    public var uri: URL? { token.uri }
}
