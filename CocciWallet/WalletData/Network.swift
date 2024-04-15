//
//  File.swift
//  
//
//  Created by Michael on 4/10/24.
//

import Foundation
import SwiftData
import OffChainKit
import Web3Kit

@Model
public class Network {
    public typealias EtherscanFetch = (String, String?) async throws -> [Etherscan.Transaction]
    public typealias BalanceFetch = (String, UInt8) async throws -> Double

    public let addressString: String
    public var card: NetworkEntity

    public var balance: Double?
    public var transactions: [Etherscan.Transaction]
        
    @Relationship(deleteRule: .nullify)
    public var tokens: [Token]
    
    @Relationship(deleteRule: .nullify)
    public var nfts: [NFT]
    
    public var settings: Settings
    
    @Transient
    public var lastUpdate: Date?
    
    public init(
        address: String,
        card: NetworkEntity,
        balance: Double? = nil,
        transactions: [Etherscan.Transaction] = [],
        nfts: [NFT] = [],
        tokens: [Token] = [],
        settings: Settings = .init()
    ) {
        self.addressString = address
        self.card = card
        self.balance = balance
        self.transactions = transactions
        self.nfts = nfts
        self.tokens = tokens
        self.settings = settings
    }
    
    
    @MainActor
    func update(context: ModelContext) async throws {
        print(self.name + " " + self.addressString.suffix(6))
        let client = EthClient(rpc: Infura.shared.URL(chainInt: card.chain)!, chain: card.chain)
        
        let balance = try? await client.fetchNativeBalance(for: addressString, decimals: 18)
        print("\tBalance: \(balance?.formatted(.number) ?? "nil")")
        self.balance = balance


        await updateTokens(with: client, context: context)
        await updateNFTs(with: client, context: context)
        
        if let transactions = try? await Etherscan.shared.getTransactions(for: addressString, explorer: card.explorer) {
            print("\tTransactions:\(transactions.count)")
            self.transactions = transactions
        }
        self.lastUpdate = .now
        print("Updated \(self.name + " " + self.addressString.suffix(6))")
    }
    
    @MainActor
    func updateTokens(with client: EthClient, context: ModelContext) async {
        do {
            let interactions = try await client.fetchTokenInteractions(for: self.addressString)
            
            interactions.forEach { contract in
                Task{ @MainActor in
                    if let token = self.tokens.first(where: {$0.address.lowercased() == contract.lowercased()}) {
                        try? await token.fetchBalance(for: self.addressString, with: client)
                    } else {
                        let (contract, balance): (ContractEntity, Double?) = try await client.fetchContractBalance(contract: contract, address: self.addressString)
                        let token = Token(contract: contract, balance: balance)
                        context.insert(token)
                        self.tokens.append(token)
                    }
                }
            }
        } catch {
            print("Token Error: \(error)")
        }
        print("\tTokens: \(self.tokens.count)")
    }
    
    @MainActor
    func updateNFTs(with client: EthClient, context: ModelContext) async {
        do {
            let interactions = try await client.fetchNFTHoldings(for: addressString)
            
            interactions.forEach { contract, tokenIds in
                tokenIds.forEach { tokenId in
                    Task { @MainActor in
                        if let nft = self.nfts.first(where: {$0.tokenId == tokenId.description}) {
                            
                        } else {
                            let entity:NFTEntity = await client.fetchNFT(tokenId: tokenId.description, contract: contract)
                            let nft = NFT(token: entity)
                            context.insert(nft)
                            self.nfts.append(nft)
                        }
                    }
                }

            }
            
        } catch {
            print("NFT Error: \(error)")
        }
    }
}



extension Network {
    
    public var chain: Int { card.chain}
    public var rpc: URL { card.rpc }
    public var name: String { card.name }
    public var symbol: String { card.symbol }
    public var decimals: UInt8 { card.decimals }
    public var hexColor: String { card.hexColor}

    
    public func needsUpdate() -> Bool {
        guard let lastUpdate = self.lastUpdate else { return true }
        let minutes: Double = 10
        let needsUpdate = Date().timeIntervalSince(lastUpdate) > (60 * minutes)
        print(self.name + " " + self.addressString.suffix(6) + ": \(lastUpdate.formatted(date: .omitted, time: .shortened))")
        return needsUpdate
    }
}


public extension Network {
    struct Settings: Codable {
        public var showBalance: Bool
        public var coverNFT: NFTEntity?
        public var blockList: [String]
        
        public init(showBalance: Bool = true, coverNFT: NFTEntity? = nil) {
            self.showBalance = showBalance
            self.coverNFT = coverNFT
            self.blockList = []
        }
    }
}

extension NFTEntity: NFTP{}
extension ContractEntity: ERCP{}
