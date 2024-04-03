//
//  WalletModel+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation
import Web3Kit




extension WalletHolder {
    static let preview = WalletHolder(wallets: [.rifigy, .wallet, .ganache])
}



fileprivate extension WalletHolder {
    convenience init(wallets: [Wallet]) {
        self.init()
        self.wallets = wallets
        select(self.wallets.first!)
//        self.selected = self.wallets.first
    }
}

import SwiftUI
extension View {
    @ViewBuilder
    func environmentPreview(_ wallet: Wallet? = nil) -> some View {
        let wallets: [Wallet] = {if let wallet {[wallet]}else{[.rifigy, .wallet]}}()
        self
            .environment(PriceModel.preview)
            .environment(wallet ?? Wallet.rifigy)
            .environment(WalletHolder(wallets: wallets))
            .environment(NetworkManager())
    }
}
