//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation
import web3
import BigInt
import ChainKit

public typealias ERC721 = Token<EthereumAddress>
extension EthereumHttpClient: ERC721Client {
        
    private var erc721: web3.ERC721 { .init(client: self) }
    private var erc721Metadata: web3.ERC721Metadata { .init(client: self, metadataSession: .shared) }

    public func getTokenBalance(contract: EthereumAddress, address: EthereumAddress) async throws -> BigUInt {
        try await erc721.balanceOf(
            contract: contract,
            address: address
        )
    }
    

    
    public func getTokenContract(address contract: EthereumAddress) async throws -> ERC721 {

        async let name: String? = try? await erc721Metadata.name(contract: contract)
        async let symbol: String? = try? await erc721Metadata.symbol(contract: contract)

        return await Token<web3.EthereumAddress>(
            contract: contract,
            name: name ?? "",
            symbol: symbol ?? "",
            decimals: 0
        )

    }
    
    public func getTokenTransferEvents(for address: EthereumAddress) async throws -> [ERC721Transfer] {
        
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
    
    public func getTokenURI(contract: EthereumAddress, tokenId: BigUInt) async throws -> URL {
        try await erc721Metadata.tokenURI(
            contract: contract,
            tokenID: tokenId
        )
    }
    
    public func ownerOf(tokenId: BigUInt, in contract: EthereumAddress) async throws -> String {
        return try await erc721.ownerOf(contract: contract, tokenId: tokenId).asString()
    }
}




extension ERC721Events.Transfer: ERC721TransferProtocol {}
public typealias ERC721Transfer = ERC721Events.Transfer
