//
//  File.swift
//  
//
//  Created by Michael on 4/14/24.
//

import Foundation
import XCTest
@testable import Web3Kit
@testable import OffChainKit

final class ClientTests: XCTestCase {

    func testClient() async {
        let dave = "0x29702A5F896A9097525C1e589DB8b818b89CB2D7"
        let client = EthClient(rpc: infura.URL(chainInt: 1)!, chain: 1)
        do {
            let nfts: [NFTEntity] = try await client.fetchNFTs(for: dave)
            XCTAssert(nfts.count > 10, "Expected more than 10 NFTs, fot \(nfts.count)")
        } catch {
            XCTFail("Expected Client to return NFTs")
        }
    }
    
}

struct NFTEntity: Codable, NFTP {
    public let tokenId: String
    public let contract: String
    public let uri: URL?
    public let metadata: Data?
    
    public var imageURL: URL?
    
    init(tokenId: String, contract: String, uri: URL?, metadata: Data?, imageURL: URL? = nil) {
        self.tokenId = tokenId
        self.contract = contract
        self.uri = uri
        self.metadata = metadata
        self.imageURL = imageURL
    }
    
//    public lazy var opensea: OpenSeaMetadata? = try? JSONDecoder().decode(OpenSeaMetadata.self, from: metadata ?? Data())

}
