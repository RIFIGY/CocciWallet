//
//  NftViewModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/26/24.
//

import Foundation
import Web3Kit
import BigInt

@Observable
class NftVM<Client:ERC721Client>: Codable {
    
    typealias Contract = Client.E721
    typealias Transfer = Client.Transfer
    
    let address: String
    var transfers: [Transfer] = []
    var tokens: [Contract: [NFTMetadata]] = [:]
    

    init(address: String) {
        self.address = address
    }
    
    
    func fetch(with client: Client) async {
        do {
            self.transfers = try await client.getTokenTransferEvents(for: address)
            await fetchNFTs(client)
            print("\tERC721 - TXs: \(self.transfers.count.description), Contracts: \(tokens.keys.count), NFTS: \(tokens.flatMap{$0.value}.count)")
        } catch {
            
        }
    }
    
    
    public func coverNft(favorite: NftEntity?) -> NFTMetadata? {
        let tokens = self.tokens.flatMap{$0.value}
        guard let favorite else {
            return tokens.first//{$0.imageURL != nil || $0.image != nil}
        }
        return tokens.first{ nft in
            let contract = nft.contract.lowercased() == favorite.contract.lowercased()
            let tokenId = nft.tokenId.description == favorite.tokenId
            return tokenId && contract
        }
    }
    
    private func fetchNFTs(_ client: Client) async {
        let filtered = client.filter(transfers: self.transfers, for: address)
        let nfts = await client.fetchNFTs(in: filtered)
        
        self.tokens = await withTaskGroup(of: (Contract, NFTMetadata).self, returning: [Contract: [NFTMetadata]].self) { group in
            for (contract, tokenIds) in nfts {
                for (tokenId, uri) in tokenIds {
                    group.addTask {
                        let nft = NFTMetadata(contract: contract, tokenId: tokenId, uri: uri, json: nil)
                        await nft.fetch()
                        return (contract, nft)
                    }
                }
            }
            
            return await group.reduce(into: [Contract: [NFTMetadata]]()) { partialResult, result in
                partialResult[result.0, default: []].append(result.1)
            }
        }
    }
}

extension NftVM {
    
    enum CodingKeys: String, CodingKey {
        case address
        case _tokens = "tokens"
    }
    
}
