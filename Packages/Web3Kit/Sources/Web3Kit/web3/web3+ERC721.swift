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

extension EthereumHttpClient: ERC721Client {
    
    private var erc721: web3.ERC721 { .init(client: self) }
    private var erc721Metadata: web3.ERC721Metadata { .init(client: self, metadataSession: .shared) }
    
    public func getTokenBalance(contract: String, address: String) async throws -> BigUInt {
        try await erc721.balanceOf(
            contract: try validate(contract),
            address: try validate(address)
        )
    }
    

    
    public func getTokenContract(address contract: String) async throws -> ChainKit.ERC721 {
        let validatedContract = try validate(contract)

        async let name: String? = try? await erc721Metadata.name(contract: validatedContract)
        async let symbol: String? = try? await erc721Metadata.symbol(contract: validatedContract)

        return await ERC721(
            contract: .init(contract),
            name: name ?? "",
            symbol: symbol ?? ""
        )

    }
    
    public func getTokenTransferEvents(for address: String) async throws -> [ERC721Transfer] {
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
    
    public func getTokenURI(contract: String, tokenId: BigUInt) async throws -> URL {
        try await erc721Metadata.tokenURI(
            contract: try validate(contract),
            tokenID: tokenId
        )
    }
    
    public func ownerOf(tokenId: BigUInt, in contract: String) async throws -> String {
        return try await erc721.ownerOf(contract: try validate(contract), tokenId: tokenId).asString()
    }
}




public typealias ERC721Transfer = ERC721Events.Transfer

extension ERC721Transfer: ERCTransfer {
    public var timestamp: Date? {
        nil
    }
    
    
}

extension ERC721Events.Transfer: ERC721TransferProtocol {
    public var sorter: String { self.log.blockNumber.stringValue }
    public var id: String {
        self.log.transactionHash ?? "\(toAddress)_\(fromAddress)_\(tokenId.description)_\(log.data)"
    }
    public var toAddress: String {
        self.to.asString()
    }
    
    public var fromAddress: String {
        self.from.asString()
    }
    
    public var bigValue: BigUInt? {
        nil
    }
    
    public var contract: String {
        self.log.address.asString()
    }
    
    public var title: String {
        "NFT Transfer"
    }
    
    public var subtitle: String {
        self.contract
    }
    
    
}
