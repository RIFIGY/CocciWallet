//
//  Storage.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/1/24.
//

import Foundation
import BigInt
import Web3Kit

typealias Storage = UserDefaults

extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.rifigy.CocciWallet")!
}
extension Storage {
    static var shared: UserDefaults { .group }
    
    func wallets<D:Decodable>() -> [D] {
        let allIDs = self.stringArray(forKey: Self.allWalletIDs)
        let decoder = JSONDecoder()
        
        return allIDs?.compactMap{
            if let data = self.data(forKey: $0) {
                return try? decoder.decode(D.self, from: data)
            } else {
                return nil
            }
        } ?? []
    }
    
    func Wallets() -> [Wallet] {
        wallets()
    }
    
    func wallet(id: Wallet.ID) -> Wallet? {
        self.getCodable(forKey: id)
    }
    
    func networks(for wallet: Wallet.ID, includeCustom: Bool = true) -> [NetworkCard] {
        let wallet = self.wallet(id: wallet)
        let cards = wallet?.cards ?? []
        let custom = wallet?.custom ?? []
        
        return includeCustom ? (cards + custom) : cards
    }
    

    func nftContracts(for wallet: Wallet.ID, in network: NetworkEntity) -> [ERC721] {
        guard let wallet = self.wallet(id: wallet),
                let card = (wallet.cards + wallet.custom ).first(where: {$0.title == network.title} ) else {return [.Munko]}
        
        return Array(card.nftInfo.tokens.keys)
    }
    

    func nfts(in network: UUID?, owner wallet: Wallet.ID) -> [NFTMetadata] {
        guard let wallet = self.wallet(id: wallet) else {return []}
        let allCards = (wallet.cards + wallet.custom)
        if let network, let card = allCards.first(where: {$0.id == network}) {
            return card.nftInfo.tokens.flatMap{$0.value}
        } else {
            return allCards.flatMap{ card in card.nftInfo.tokens.flatMap{$0.value} }
        }
    }
    
    func nfts(for contract: String, in network: UUID, owner wallet: Wallet.ID) -> [NFTMetadata] {
        guard let wallet = self.wallet(id: wallet),
              let card = (wallet.cards + wallet.custom ).first(where: {$0.id == network} ) else {return []}
        
        guard let erc = card.nftInfo.tokens.keys.first(where: {$0.id == contract} ) else {return [] }
        
        return card.nftInfo.tokens[erc] ?? []
    }
    
    func tokenContracts(for wallet: Wallet.ID, in network: UUID?) -> [ ERC20 ] {
        guard let wallet = self.wallet(id: wallet) else {return []}
        let allCards = (wallet.cards + wallet.custom)
        
        if let network, let card = allCards.first(where: {$0.id == network}) {
            return card.tokenInfo.balances.map{$0.key}
        } else {
            return allCards.flatMap{ card in card.tokenInfo.balances.map{$0.key} }
        }
    }
    
    func balance(of contract: String, in wallet: Wallet.ID, on network: UUID?) -> Double? {
        guard let wallet = self.wallet(id: wallet),
              let card = (wallet.cards + wallet.custom ).first(where: {$0.id == network} ) else {return nil}
        
        guard let erc = card.tokenInfo.balances.keys.first(where: {$0.id == contract} ) else {return nil }

        
        return card.tokenInfo.balances[erc]?.value(decimals: erc.decimals)
    }
    
}
