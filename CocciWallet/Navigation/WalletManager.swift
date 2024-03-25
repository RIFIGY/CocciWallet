//
//  WalletHollder.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation
import Web3Kit
import KeychainSwift
import web3


@Observable
class WalletHolder {
    
    var wallets: [WalletModel]
    var selected: WalletModel?
    
    var showNewWallet = false

    private let cache: any Cache
//    let generator: WalletGenerator
    
    private let store = KeychainSwift.shared
    
    init(cache: any Cache = UserDefaults.standard) {
        self.cache = cache
//        self.generator = .init(storage: KeychainSwift.shared)
        let cached = Self.buildModels(from: cache)
        self.wallets = cached
        self.selected = self.wallets.first
    }
    
    
    private static func buildModels(from cache: any Cache) -> [WalletModel] {
        let storedKeys = KeychainSwift.shared.allKeys.map{$0}
        
        var cached = Wallet.fetchWallets(from: cache)
        let watch = cached.filter{ $0.type == .watch }
                
        let keyedModels = storedKeys.compactMap { address in
            let wallet = cached.first{$0.address == address}
            if let wallet {
                return WalletModel(wallet)
            } else {
                return nil
            }
        }
        
        let watchModels = watch.map{ WalletModel($0) }
        
        return keyedModels + watchModels
        

    }
    
    
    func add(wallet: Wallet) {
        let name = wallet.name.isEmpty ? wallets.nextName : wallet.name
        let wallet = Wallet(address: wallet.address, name: name, type: wallet.type, blockHD: wallet.blockHD)
        save(wallet)
        let model = WalletModel(wallet)
        
        self.wallets.append(model)
        self.selected = model
    }
    
    func delete(wallet model: WalletModel) async throws {
        guard let index = wallets.firstIndex(of: model) else {return}
        
        try await deletePrivateKey(for: model.address)
        
        delete(model.address)
        wallets.remove(at: index)
        
        if wallets.isEmpty {
            self.selected = nil
        } else {
            self.selected = wallets.first
        }
    }
    
    func getAccount(for address: String, password: String = "") async throws -> EthereumAccount {
        guard try await Authentication.authenticate() else { 
            throw Authentication.Error.didNotAuthenticate
        }
        let account = try EthereumAccount(addressString: address, keyStorage: store, keystorePassword: password)
        return account
        
    }
    
    fileprivate func deletePrivateKey(for address: String) async throws {
        guard try await Authentication.authenticate() else {return}
        try store.deletePrivateKey(address: address)
    }
    
}

fileprivate extension Array where Element == WalletModel {
    var nextName: String {
        self.isEmpty ? "MyWallet" : "MyWallet\(self.count + 1)"
    }
}


extension WalletHolder {
    private var kWallets:String { "wallet_keys" }
    static private var kWallets: String { "wallet_keys"}
    
    private func save(_ wallet: Wallet) {
        var keys = cache.fetch([Wallet].self, for: kWallets) ?? []
        guard !keys.contains(wallet) else {return}
        keys.append(wallet)
        cache.store(keys, forKey: kWallets)
    }
    
    private func delete(_ wallet: Wallet.ID) {
        var keys = cache.fetch([Wallet].self, for: kWallets) ?? []
        guard let index = keys.firstIndex(where: { $0.id == wallet }) else {return}
        keys.remove(at: index)
        cache.store(keys, forKey: kWallets)
    }
}
