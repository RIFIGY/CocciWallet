//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt

public protocol ERC721Protocol: ERC {
    associatedtype T : ERC721TokenProtocol
}

public protocol ERC721TokenProtocol: Codable, Identifiable, Equatable, Hashable {
    associatedtype C : ERC721Protocol
    var token: C {get}
    var contract: String {get}
    var tokenId: BigUInt {get}
    var uri: URL? {get}
    var metadata: Data? {get}

}

extension ERC721TokenProtocol {
    public var contract: String { token.contract }
    public var id: String { contract + "_" + tokenId.description }
}


public struct ERC721: ERC721Protocol {
    public typealias T = Token
    
    public let contract: String
    public let name: String?
    public let symbol: String?
    public let description: String?
    public var baseURI: URL? = nil
    
    public struct Token: ERC721TokenProtocol {
        public let token: ERC721
        public let tokenId: BigUInt
        public var uri: URL? = nil
        public var metadata: Data? = nil
        
        public typealias Metadata = OpenSeaMetadata

        public func decodeMetadata(decoder: JSONDecoder = JSONDecoder() ) throws -> Metadata? {
            guard let metadata else {return nil}
            return try decoder.decode(Metadata.self, from: metadata)
        }
        
    }
    
}

public protocol ERC721Enumerable: ERC721Protocol {
    var baseURI: URL? {get}
}
