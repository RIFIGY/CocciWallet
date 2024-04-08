//
//  EthereumNetworkCard.swift
//  CocciWallet
//
//  Created by Michael on 4/7/24.
//

import Foundation
import Web3Kit
import ChainKit
import BigInt


class EthereumNetworkCard: Network {
    var chain: Int
    var rpc: URL
    var settings: Settings
    var tokens: Tokens
    var nfts: NFTs

    let ethereum: Web3Kit.EthereumClient
    var client: Web3Kit.EthereumClient.Client {
        ethereum.node
    }
    
    public init(chain: Int, rpc: URL, nativeCoin: ChainKit.Coin, name: String? = nil, hexColor: String? = nil, explorerPrefix: String? = nil) {
        self.chain = chain
        self.rpc = rpc
        self.settings = Settings()
        self.tokens = Tokens()
        self.nfts = NFTs()
        self.ethereum = .init(rpc: rpc, chain: chain)
        super.init(nativeCoin: nativeCoin, name: name, hexColor: hexColor, explorerPrefix: explorerPrefix)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        chain = try container.decode(Int.self, forKey: ._chain)
        rpc = try container.decode(URL.self, forKey: ._rpc)
        settings = try container.decode(Settings.self, forKey: ._settings)
        tokens = try container.decode(Tokens.self, forKey: ._tokens)
        nfts = try container.decode(NFTs.self, forKey: ._nfts)
        ethereum = EthereumClient(rpc: rpc, chain: chain)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(chain, forKey: ._chain)
        try container.encode(rpc, forKey: ._rpc)
        try container.encode(settings, forKey: ._settings)
        try container.encode(tokens, forKey: ._tokens)
        try container.encode(nfts, forKey: ._nfts)

        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case _chain = "chain"
        case _rpc = "rpc"
        case _settings = "settings"
        case _tokens = "tokens"
        case _nfts = "nfts"
    }
    
    func update(address: String) async -> Bool {
        guard needUpdate(), !isUpdating else {return false}
        await withTaskGroup(of: Void.self) { group in
            
            group.addTask {
                await self.fetchTransactions(for: address)
            }
            group.addTask {
                self.balance = try? await self.client.getBalance(address: address, block: nil)
            }
            group.addTask {
                await self.tokens.fetch(address: address, with: self.client)
            }
            group.addTask {
//                await self.nftInfo.fetch(with: client)
            }
        }
        return true

    }
    struct Settings: Codable {
        var showBalance = true
        var coverNFT: NftEntity? = nil
    }
}

@Observable
class Tokens: Codable {
    
    var balances: [ERC20 : BigUInt] = [:]
    var events: [ERC20Transfer] = []
    

    var contractInteractions: [String] {
        Array(Set(events.map{$0.contract}))
    }
    
    func fetch<C:ERC20Client>(address: String, with client: C) async {
        if let events = try? await client.getTransferEvents(for: address) {
            print("\tERC20 - TXs: \(events.count.description), Tokens: \(contractInteractions.count.description)")
            self.events = events
        }
        
        if let balances = try? await client.fetchBalances(for: address, in: contractInteractions) {
            balances.forEach { contract, balance in
                self.balances[contract] = balance
            }
        }
    }
    
    func totalValue(chain: Int, _ priceModel: PriceModel, currency: String) -> Double {
        balances.compactMap { contract, balance in
            let value = balance.value(decimals: contract.decimals)
            let price = priceModel.price(chain: chain, contract: contract.contract.string, currency: currency)
            if let price {
                return price * value
            } else {
                return 0
            }
        }
        .reduce(0, +)
    }
}

extension Tokens {
    enum CodingKeys: String, CodingKey {
        case _balances = "balances"
    }

}


@Observable
class NFTs: Codable {
    var tokens: [ERC721: [NFTMetadata]] = [:]
    
    func fetch<Client:ERC721Client>(address: String, with client: Client) async {
        guard let transfers = try? await client.getTokenTransferEvents(for: address) else {return}
        let filtered = client.filter(transfers: transfers, for: address)
        let nfts = await client.fetchNFTs(in: filtered)
        self.tokens = await withTaskGroup(of: (ERC721, NFTMetadata).self, returning: [ERC721: [NFTMetadata]].self) { group in
            for (contract, tokenIds) in nfts {
                for (tokenId, uri) in tokenIds {
                    group.addTask {
                        let nft = NFTMetadata(contract: contract, tokenId: tokenId, uri: uri, json: nil)
                        await nft.fetch()
                        return (contract, nft)
                    }
                }
            }
            
            return await group.reduce(into: [ERC721: [NFTMetadata]]()) { partialResult, result in
                partialResult[result.0, default: []].append(result.1)
            }
        }
    }
}


extension NFTs {
    enum CodingKeys: String, CodingKey {
        case _tokens = "tokens"
    }

}
