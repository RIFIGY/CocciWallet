// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftData
//import ChainKit
import Foundation
//import Web3Kit
import BigInt

@MainActor
public class WalletContainer {
    
    public static let shared = WalletContainer()
//    static let group = UserDefaults(suiteName: "group.rifigy.CocciWallet")!

    public let container: ModelContainer
    
    private init(inMemory:Bool = false){
        let schema = Schema([
            Web3Wallet.self
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
    
    
    func fetchWeb3Wallet(address: String) async -> Web3Wallet? {
        let predicate = #Predicate<Web3Wallet> { $0.id == address }
        return try? container.mainContext.fetch(.init(predicate: predicate)).first
    }
}

public extension WalletContainer {
    
    func fetchNetworks(wallet: String) async throws -> [Network] {
        guard let wallet = await fetchWeb3Wallet(address: wallet) else {return []}
        return wallet.networks
    }
    
    func fetchNetwork(wallet: String, chain: Int) async -> Network? {
        try? await fetchNetworks(wallet: wallet).first{$0.chain == chain}
    }
    
    func fetchNetwork(wallet: String, networkID: String) async -> Network? {
        try? await fetchNetworks(wallet: wallet).first{$0.id == networkID}
    }
    
}

public extension WalletContainer {
    
    func fetchAllContracts() async -> [ContractEntity] {
        await allWallets().flatMap{$0.networks}.flatMap{$0.tokens}.map{$0.contract}
    }
    
    func fetchTokens(wallet: String, networkID: String) async -> [Token] {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID) else {return []}
        return network.tokens
    }
    
    func fetchToken(wallet: String, networkID: String, contract: String) async -> Token? {
        return await fetchTokens(wallet: wallet, networkID: networkID).first{$0.contract.address.lowercased() == contract.lowercased()}
    }
    
    func fetchBalance(wallet: String, networkID: String, contract: String) async -> Double? {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID)
        else {return nil}
        return network.tokens.map{$0}.first(where: {$0.contract.address.lowercased() == contract.lowercased()} )?.balance

    }
    
}

public extension WalletContainer {
    typealias NFT = WalletData.NFT
    
    func fetchAllNFTs() async -> [NFT] {
        let wallets = await allWallets()
        return wallets.flatMap{$0.networks}.flatMap{$0.nfts}
    }
    
    func fetchAllNFTs(wallet: String, networkID: String? = nil, contract: String? = nil) async -> [NFT] {
        guard let walletModel = await fetchWeb3Wallet(address: wallet) else {return []}
        guard let networkID else {
            var nfts = [NFT]()
            walletModel.networks.forEach { network in
                let _nfts = network.nfts
                nfts.append(contentsOf: _nfts)
            }
            return nfts
        }
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID) else {return []}
        return network.nfts

//        if let contract {
//            return network.nfts.flatMap{$0.value}.filter{$0.}
//        } else {
//            return network.nfts.flatMap{$0.value}
//        }
    }
    
    func fetchNFTContracts(wallet: String, networkID: String) async -> [String] {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID) else {return []}
        return network.nfts.map{$0.contract}
    }
    
    func fetchNFTs(wallet: String, networkID: String, contract: String) async -> [NFT] {
        guard let network = await fetchNetwork(wallet: wallet, networkID: networkID)
            else {return [] }
        
        return network.nfts.filter{$0.contract.lowercased() == contract.lowercased()}
    }
    
    func fetchNFT(wallet: String, networkID: String, contract: String, tokenId: BigUInt) async -> NFT? {
        await fetchNFTs(wallet: wallet, networkID: networkID, contract: contract).first{$0.tokenId == tokenId.description}
    }

}
