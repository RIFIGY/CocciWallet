//
//  CocciWalletApp.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI

@main
struct CocciWalletApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct LocalChain {
    static let ganache_private_key = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
    static let ganache_address = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
}
