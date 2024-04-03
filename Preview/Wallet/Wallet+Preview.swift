//
//  Wallet+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/31/24.
//

import Foundation

extension Wallet {
    static let rifigy = Wallet(address: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", name: "Rifigy", type: .watch, blockHD: "ETH")

    static let wallet = Wallet(address: "0x93d10aef2A21628C6ae5B5D91BF1312b522f626b", name: "Wallet", type: .watch, blockHD: "ETH")
    static let dave = Wallet(address: "0x29702A5F896A9097525C1e589DB8b818b89CB2D7", name: "Dave", type: .watch, blockHD: "ETH")
    static let ganache = Wallet(address: LocalChain.ganache_address, name: "Ganache", type: .privateKey, blockHD: "ETH")
}

extension WalletEntity {
    static let rifigy = WalletEntity(name: Wallet.rifigy.name, address: Wallet.rifigy.address)
    static let wallet = WalletEntity(name: Wallet.wallet.name, address: Wallet.wallet.address)
    static let dave = WalletEntity(name: Wallet.dave.name, address: Wallet.dave.address)
    static let ganache = WalletEntity(name: Wallet.ganache.name, address: Wallet.ganache.address)

}
