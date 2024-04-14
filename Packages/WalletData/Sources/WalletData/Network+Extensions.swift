////
////  File.swift
////  
////
////  Created by Michael on 4/13/24.
////
//
//import Foundation
//import Web3Kit
//import ChainKit
//import SwiftData
//import OffChainKit
//import BigInt
//
//extension Network {
//    public typealias Client = EthereumClient.Client
//    
//    public var address: PrivateKeyWallet.Address { wallet.address }
//
//    
//    public func update(with client: EthereumClient.Client, etherscan: EtherscanFetch) async -> Bool {
//        guard needsUpdate() else {
//            return false
//        }
//        
//        if let transactions = try? await etherscan(self.address.string, "etherscan.io") {
//            Task { @MainActor in
//                self.transactions = transactions
//            }
//        }
//        
//        await fetchBalance(with: client)
//        await fetchTokens(with: client)
//        await fetchNFTs(with: client)
//
//        self.lastUpdate = .now
//        return true
//    }
//    
//    public func updateTokenBalances(with client: Client) async {
////        for token in self.tokens {
////            Task {
////                try? await token.update(address:self.address.string, with: client)
////            }
////        }
//    }
//    
//    
//    private func fetchBalance(with client: Client) async {
//        if let balance = try? await client.fetchBalance(for: address) {
//            let divisor = BigUInt(10).power(Int(decimals))
//            let decimalValue = Double(balance) / Double(divisor)
//            Task { @MainActor in
//                self.balance = decimalValue
//            }
//        }
//    }
//    
//    private func fetchTokens(with client: Client) async {
//        if let tokens = try? await client.fetchTokens(for: address) {
//            let coins = tokens.map { contract, value in
//                let divisor = BigUInt(10).power(Int(contract.decimals ?? 18))
//                let balance = Double(value) / Double(divisor)
//                return Token(address: contract.contract.string, name: contract.name, symbol: contract.symbol, decimals: contract.decimals, balance: balance)
//            }
//            Task{@MainActor in
//                self.tokens = coins
//            }
//        }
//    }
//    
//    private func fetchNFTs(with client: Client) async {
//        if let nfts = try? await fetchNFTSwithMetadata(for: address, with: client) {
//            Task {@MainActor in
//                self.nfts = nfts.flatMap{$0.value}
//            }
//        }
//    }
//    
//    
//    private func fetchNFTSwithMetadata(for address: Web3Kit.EthereumAddress, with node: EthereumClient.Client) async throws -> [ERC721 : [WalletData.NFT] ] {
//        let nfts = try await node.fetchNFTS(for: address)
//        return [:]
//    }
//}
//
//
////extension NFT {
////    public convenience init<N:ChainKit.ERC721Protocol>(nft: N, contract: any Contract, json: Data? = nil) {
////        self.init(tokenId: nft.tokenId.description, contract: contract.contract.string, contractName: contract.name, symbol: contract.symbol, uri: nft.uri, json: json)
////    }
////}
