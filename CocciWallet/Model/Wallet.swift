//
//  WalletModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation
import Web3Kit

@Observable
class WalletModel {
    private let wallet: Wallet
    
    var cards: [NetworkCard] = []
    var custom: [NetworkCard] = []
        
    var cache: any Cache
    
    var name: String { wallet.name }
    var address: String { wallet.address }
    var type: WalletKey { wallet.type }
    
    var totalValue: Double { cards.compactMap { $0.balance }.reduce(0, +) }

    
    init(_ wallet: Wallet, cache: any Cache = UserDefaults.standard) {
        self.wallet = wallet
        self.cache = cache
        
        let cards = wallet.cards(from: cache, custom: false)
//        var custom = wallet.cards(from: cache, custom: true)

        let custom = [EVM.custom]
        
        self.cards = Array(Set(cards)).map{ .init(evm: $0, address: wallet.address) }
        self.custom = Array(Set(custom)).map{ .init(evm: $0, address: wallet.address) }

    }
    
    func add(_ evm: EVM, custom: Bool) {
        save(card: evm, address: address, custom: custom)
        
        let card = NetworkCard(evm: evm, address: address)
        if custom {
            self.custom.append(card)
        } else {
            self.cards.append(card)
        }
    }
    
    func remove(_ evm: EVM) {
        let custom: Bool = custom.map{$0.evm}.contains(evm)
        print("Trying to delete \(evm.id) custom: \(custom)")
        let cards = (custom ? self.custom : self.cards)
        guard let index = cards.firstIndex(where: { $0.evm.id == evm.id } ) else {return}
        delete(card: evm, address: address, custom: custom)
        if custom {
            self.custom.remove(at: index)
        } else {
            self.cards.remove(at: index)
        }
        print("Deleted")
    }

  
}
public struct Wallet: Codable {

    public let address: String
    public var name: String
    var type: WalletKey
    public let blockHD: String
    
    
    static func fetchWallets(from cache: any Cache) -> [Wallet] {
        cache.fetch([Wallet].self, for: "wallet_keys") ?? []
    }
    
    func cards(from cache: any Cache, custom: Bool) -> [EVM] {
        let key = Self.cardKey(address: self.address, custom: custom)
        return cache.fetch([EVM].self, for: key) ?? []
        
    }
    
    fileprivate static func cardKey(address: String, custom: Bool) -> String {
        "\(address)_\(custom ? "custom_cards" : "cards")"
    }
}

fileprivate extension WalletModel {
    
    func save(card evm: EVM, address: String, custom: Bool) {
        let cards = wallet.cards(from: cache, custom: custom)
        
        var set = Set(cards)
        set.insert(evm)
        let array = Array(set)
        
        cache.store(array, forKey: Wallet.cardKey(address: address, custom: custom))
    }
    
    func delete(card evm: EVM, address: String, custom: Bool) {
        var cards = wallet.cards(from: cache, custom: custom)
        
        guard let index = cards.firstIndex(of: evm) else { print("No index"); return}
        cards.remove(at: index)
        
        cache.store(cards, forKey: Wallet.cardKey(address: address, custom: custom))
    }
}




extension Wallet: Identifiable, Equatable, Hashable {
    public var id: String { address }

    public static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        lhs.id == rhs.id
    }
}

extension WalletModel: Identifiable, Equatable, Hashable {
    var id: String { wallet.id }

    static func == (lhs: WalletModel, rhs: WalletModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(wallet)
    }
}



fileprivate extension EVM {
    static var custom: EVM {
        .init(rpc: URL(string: "HTTP://127.0.0.1:7545")!, chain: 1337, name: "Ganache", symbol: "TEST", explorer: "etherscan.io", color: .teal)
    }
}
