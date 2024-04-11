//
//  Navigation.swift
//  CocciWallet
//
//  Created by Michael on 4/10/24.
//

import Foundation
import WalletData

@Observable
class Navigation {
    
    var selected: Wallet?
    var selectedNetwork: EthereumNetworkCard?
    
    var showNewNetwork = false
    var showSettings = false
    var showWallets = false
    
//    var path: [NavigationPath]
    
    func select(from wallets: [Wallet], lastSelected: String) {
        if lastSelected.isEmpty {
            self.selected = wallets.first
        } else {
            self.selected = wallets.first{$0.id == lastSelected}
        }
    }
    
}
