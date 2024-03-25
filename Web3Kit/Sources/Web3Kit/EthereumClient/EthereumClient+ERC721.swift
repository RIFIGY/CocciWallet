//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import BigInt
import web3
import Logging

extension EthereumClient: ERC721Client {
    
    public func getERC721Balance(contract: String, address: String) async throws -> BigUInt {
        try await client.getERC721Balance(contract: contract, address: address)
    }
    
    public func getERC721Contract(for contract: String) async throws -> ERC721 {
        try await client.getERC721Contract(for: contract)
        
    }
        
    public func getERC721TransferEvents(for address: String) async throws -> [ERC721Transfer] {
        try await client.getERC721TransferEvents(for: address)
    }
    
    
    public func getERC721URI(contract: String, tokenId: BigUInt) async throws -> URL {
        let key = contract + "_" + tokenId.description + "_uri"
        if let uri = cache?.fetch(URL.self, for: key) { return uri }
        
        let uri = try await client.getERC721URI(contract: contract, tokenId: tokenId)
        
        cache?.store(uri, forKey: key, expiresIn: (1, .day))
        
        return uri
    }
    
}
