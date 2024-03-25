//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import web3
import BigInt

extension EthereumHttpClient: ERC721Client {
    
    private var erc721: web3.ERC721 { .init(client: self) }

    
    public func getERC721Balance(contract: String, address: String) async throws -> BigUInt {
        try await erc721.balanceOf(
            contract: try validate(contract),
            address: try validate(address)
        )
    }
    
    public func getERC721TransferEvents(for address: String) async throws -> [ERC721Transfer] {
        let address = try validate(address)
        
        async let to = try await self.erc721.transferEventsTo(
            recipient: address,
            fromBlock: .Earliest,
            toBlock: .Latest
        )
        async let from = try await self.erc721.transferEventsFrom(
            sender: address,
            fromBlock: .Earliest,
            toBlock: .Latest
        )
        
        return try await to + from

    }
}

extension EthereumHttpClient {
    
    private var erc721Metadata: web3.ERC721Metadata {
        web3.ERC721Metadata(client: self, metadataSession: URLSession.shared)
    }
    
    public func getERC721Contract(for contract: String) async throws -> ERC721 {
        let contract = try validate(contract)

        async let name: String? = try? await erc721Metadata.name(contract: contract)
        async let symbol: String? = try? await erc721Metadata.symbol(contract: contract)

        return await ERC721(
            contract: contract.asString(),
            name: name,
            symbol: symbol,
            description: nil
        )

    }
    
    public func getERC721URI(contract: String, tokenId: BigUInt) async throws -> URL {
        try await erc721Metadata.tokenURI(
            contract: try validate(contract),
            tokenID: tokenId
        )
    }
}

extension EthereumHttpClient {
    
    private var erc721Enumerable: web3.ERC721Enumerable {
        .init(client: self)
    }
  
}
