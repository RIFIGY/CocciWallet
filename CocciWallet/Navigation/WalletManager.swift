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
import OffChainKit

@Observable
class WalletHolder {
    
    var wallets: [Wallet]
    private(set) var selected: Wallet?
    
    var showNewWallet = false
    
    private let cache: any Cache = UserDefaults.group
    
    private let store = KeychainSwift.shared
    
    init() {
        let cached = Self.buildModels(from: cache)
        self.wallets = cached
        print("Cached: \(cached.count)")
    }
    
    func save() {
        Storage.shared.setValue(wallets.map{$0.address}, forKey: Storage.allWalletIDs)
        let ids = Storage.shared.stringArray(forKey: Storage.allWalletIDs) ?? []
        print(ids.count)
        print(self.wallets.count)

    }
    
    func select(_ wallet: Wallet) {
        self.selected = wallet
    }
    
    func select(id: Wallet.ID) {
        guard let wallet = wallets.first(where: {$0.id == id} ) else {
            self.selected = wallets.first
            return
        }
        select(wallet)
    }
    
    func add(wallet: Wallet) {
        wallet.name = wallet.name.isEmpty ? wallets.nextName : wallet.name
        guard !self.wallets.contains(wallet) else {return}
        self.wallets.append(wallet)
        self.select(wallet)
        wallet.save()
        save()
    }
    

    
    func delete(wallet model: Wallet) async throws {
        guard let index = wallets.firstIndex(of: model) else {return}
        
        try await deletePrivateKey(for: model.address)
        wallets.remove(at: index)
        
        if wallets.isEmpty {
            self.selected = nil
        } else {
            self.selected = wallets.first
        }
        save()
    }
}

extension WalletHolder {
    
    func getAccount(for address: String, password: String = "") async throws -> EthereumAccount {
        guard try await Authentication.authenticate() else { 
            throw Authentication.Error.didNotAuthenticate
        }
        let account = try EthereumAccount(addressString: address, keyStorage: store, keystorePassword: password)
        return account
    }
    
    func getPrivateKey(for address: String, password: String = "") async throws -> Data {
        guard try await Authentication.authenticate() else {
            throw Authentication.Error.didNotAuthenticate
        }
        return try store.loadPrivateKey(address: address)
    }
    
    fileprivate func deletePrivateKey(for address: String) async throws {
        guard try await Authentication.authenticate() else {return}
        try store.deletePrivateKey(address: address)
    }
    
}

fileprivate extension Array where Element == Wallet {
    var nextName: String {
        self.isEmpty ? "MyWallet" : "MyWallet\(self.count + 1)"
    }
}


extension WalletHolder {
    
    private static func buildModels(from cache: any Cache) -> [Wallet] {
        let storedKeys = KeychainSwift.shared.allKeys.map{$0}
        let ids = Storage.shared.stringArray(forKey: Storage.allWalletIDs) ?? []
        print("Cached IDs: \(ids.count)")
        var cached = Storage.shared.Wallets()

                
        let keyedModels = storedKeys.compactMap { address in
            let wallet = cached.first{$0.address == address}
            if let wallet {
                return wallet
            } else {
                return nil
            }
        }
        
        let watchWallets = cached.filter{ $0.type == .watch }
        
        return keyedModels + watchWallets

    }
}
