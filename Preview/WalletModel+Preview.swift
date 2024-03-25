//
//  WalletModel+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation

extension WalletModel {
    static let rifigy = WalletModel(.rifigy)
    static let wallet = WalletModel(.wallet)
}

extension NetworkCard {
    static let ETH = NetworkCard(evm: .ETH, address: Wallet.rifigy.address)
}

extension WalletHolder {
    static let preview = WalletHolder(wallets: [.rifigy, .wallet])
}

fileprivate extension WalletHolder {
    convenience init(wallets: [Wallet]) {
        self.init()
        self.wallets = wallets.map{ .init($0) }
        self.selected = self.wallets.first
    }
}
