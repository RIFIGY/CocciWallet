// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftData
import ChainKit
import Foundation
import Web3Kit
import BigInt

@MainActor
public class WalletContainer {
    
    public static let shared = WalletContainer()
//    static let group = UserDefaults(suiteName: "group.rifigy.CocciWallet")!

    public let container: ModelContainer
    
    private init(inMemory:Bool = false){
        let schema = Schema([
            Web3Wallet.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory, allowsSave: true)
                
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.container = container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

    }
}


public extension WalletContainer {
    
    func allWallets() async -> [Web3Wallet] {
        let descriptor: FetchDescriptor<Web3Wallet> = .init()
        let wallets = try? container.mainContext.fetch(descriptor)
        return wallets ?? []
    }
    
    func fetchWeb3Wallet(address: Web3Kit.EthereumAddress) async -> Web3Wallet? {
        return await fetchWeb3Wallet(address: address.string)
    }
    
    func fetchWeb3Wallet(address: String) async -> Web3Wallet? {
        let predicate = #Predicate<Web3Wallet> { $0.id == address }
        return try? container.mainContext.fetch(.init(predicate: predicate)).first
    }
}

public extension WalletContainer {
    
    func fetchNetworks(wallet: String) async throws -> [Web3Network] {
        guard let wallet = await fetchWeb3Wallet(address: wallet) else {return []}
        return wallet.networks
    }
    
    func fetchNetwork(wallet: String, chain: Int) async -> Web3Network? {
        try? await fetchNetworks(wallet: wallet).first{$0.chain == chain}
    }
    
    func fetchNetwork(wallet: String, networkID: String) async -> Web3Network? {
        try? await fetchNetworks(wallet: wallet).first{$0.id == networkID}
    }
    
}

public extension WalletContainer {
    func fetchTokens(wallet: String, networkID: String) async -> [ERC20] {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID) else {return []}
        return network.tokens.map{$0.key}
    }
    
    func fetchToken(wallet: String, networkID: String, contract: String) async -> ERC20? {
        return await fetchTokens(wallet: wallet, networkID: networkID).first{$0.contract.string.lowercased() == contract.lowercased()}
    }
    
    func fetchBalance(wallet: String, networkID: String, contract: String) async -> BigUInt? {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID),
              let token = network.tokens.map{$0.key}.first(where: {$0.contract.string.lowercased() == contract.lowercased()} )
        else {return nil}
        return network.tokens[token]

    }
    
}

public extension WalletContainer {
    typealias NFT = WalletData.NFT
    
    func fetchAllNFTs(wallet: String, networkID: String? = nil, contract: String? = nil) async -> [NFT] {
        guard let walletModel = await fetchWeb3Wallet(address: wallet) else {return []}
        guard let networkID else {
            var nfts = [NFT]()
            walletModel.networks.forEach { network in
                let _nfts = network.nfts.flatMap{$0.value}
                nfts.append(contentsOf: _nfts)
            }
            return nfts
        }
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID) else {return []}
        return network.nfts.flatMap{$0.value}

//        if let contract {
//            return network.nfts.flatMap{$0.value}.filter{$0.}
//        } else {
//            return network.nfts.flatMap{$0.value}
//        }
    }
    
    func fetchNFTContracts(wallet: String, networkID: String) async -> [ERC721] {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID) else {return []}
        return network.nfts.map{$0.key}
    }
    
    func fetchNFTs(wallet: String, networkID: String, contract: String) async -> [NFT] {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID),
              let token = network.nfts.keys.filter{$0.contract.string.lowercased() == contract.lowercased()}.first
            else {return [] }
        
        return network.nfts[token] ?? []
    }
    
    func fetchNFT(wallet: String, networkID: String, contract: String, tokenId: BigUInt) async -> NFT? {
        await fetchNFTs(wallet: wallet, networkID: networkID, contract: contract).first{$0.tokenId == tokenId}
    }

}
