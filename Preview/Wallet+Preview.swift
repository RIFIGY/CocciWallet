//
//  Wallet+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/31/24.
//

import Foundation
import Web3Kit

extension EthereumAddress {
    static let rifigy = EthereumAddress("0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0")
    static let wallet = EthereumAddress("0x93d10aef2A21628C6ae5B5D91BF1312b522f626b")
    static let dave = EthereumAddress("0x29702A5F896A9097525C1e589DB8b818b89CB2D7")

}

extension Wallet {
    static let rifigy: Wallet = {
        let wallet = Wallet(address: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", name: "Rifigy", type: .watch)
        wallet.networks.append(.preview)
        return wallet

    }()

    static let wallet: Wallet = {
        let wallet = Wallet(address: "0x93d10aef2A21628C6ae5B5D91BF1312b522f626b", name: "Wallet", type: .watch)
        wallet.networks.append(.preview)
        return wallet

    }()
    
    static let dave: Wallet = {
        let wallet = Wallet(address: "0x29702A5F896A9097525C1e589DB8b818b89CB2D7", name: "Dave", type: .watch)
        wallet.networks.append(.preview)
        return wallet

    }()
    
    static let ganache = Wallet(address: LocalChain.ganache_address, name: "Ganache")
}




//extension Wallet {
//    static var previewWallets: [Wallet] { [
//        Wallet(address: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", name: "Rifigy"),
//        Wallet(address: "0x93d10aef2A21628C6ae5B5D91BF1312b522f626b", name: "Wallet"),
//        Wallet(address: "0x29702A5F896A9097525C1e589DB8b818b89CB2D7", name: "Dave"),
//        Wallet(address: .init(LocalChain.ganache_address), name: "Ganache")
//    ]}
//}
