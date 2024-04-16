//
//  Network.swift
//  CocciWallet
//
//  Created by Michael on 4/7/24.
//

import SwiftUI
import Web3Kit
import OffChainKit
import SwiftData

extension Network {
    
    var address: Web3Kit.EthereumAddress { 
        .init(addressString)
    }
    
    var color: Color {
        Color(hex: hexColor)!
    }
        
    var isCustom: Bool {
        !NetworkEntity.chains.contains(self.chain)
    }
}

extension Network {
    
    @MainActor
    func update(context: ModelContext) async throws {
        print(self.name + " " + self.addressString.suffix(6))
//        guard let rpc = Infura.shared.URL(chain: card.chain) else {return}
        let client = EthClient(rpc: self.rpc, chain: card.chain)
        
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

extension NFTEntity: NFTP{}
extension ContractEntity: ERCP{}


extension NetworkEntity {
    
    static let selection: [NetworkEntity] = [.ETH, .ARB, .AVAX, .MATIC] // .BNB]
    
    static let chains: [Int] = selection.map{$0.chain}
    
    fileprivate init(chain: Int, rpc: URL? = nil, name: String, coin: String? = nil, symbol: String, explorer: String? = nil, color: String) {
        self.chain = chain
        let rpc = rpc ?? Infura.shared.URL(chainInt: chain)!
        self.rpc = rpc
        self.hexColor = color
        self.name = name
        self.coin = coin ?? name
        self.symbol = symbol
        self.decimals = 18
        self.explorer = explorer ?? ""
    }
    
    static let ETH = NetworkEntity(
        chain: 1,
        name: "Ethereum",
        symbol: "ETH",
        explorer: "etherscan.io",
        color: "#627eea"
    )
    
    static let MATIC = NetworkEntity(
        chain: 137,
        name: "Polygon",
        symbol: "MATIC",
        explorer: "polygonscan.com",
        color: "#6f41d8"
    )
    static let ARB = NetworkEntity(
        chain: 42161,
        name: "Arbitrum",
        symbol: "ARB",
        color: "#162C4E"
    )
    
    static let AVAX = NetworkEntity(
        chain: 43114,
        name: "Avalanche",
        symbol: "AVAX",
        explorer: "snowtrace.io",
        color: "#e84142"
    )
    

}

extension NetworkEntity {
    static func Local(url: URL? = nil) -> NetworkEntity {
        NetworkEntity(
            chain: 1337,
            rpc: url ?? URL(string: "HTTP://127.0.0.1:7545")!,
            name: "Ganache",
            symbol: "TEST",
            explorer: "etherscan.io",
            color: "#1b9e65"
        )
    }
}
