//
//  Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation

extension Wallet {
    static var rifigy: Wallet {
        .init(address: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", name: "Rifigy", type: .watch, blockHD: "ETH")
    }
    
    static var wallet: Wallet {
        .init(address: "0x93d10aef2A21628C6ae5B5D91BF1312b522f626b", name: "Wallet", type: .watch, blockHD: "ETH")
    }
}
