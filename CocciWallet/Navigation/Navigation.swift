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
        
    
    func select(from wallets: [Wallet], lastSelected: String) {
        
        let wallet: Wallet?
        
        if lastSelected.isEmpty {
            wallet = wallets.first
        } else {
            wallet = wallets.first{$0.id == lastSelected}
        }
        
        self.selected = wallet
        self.selectedNetwork = wallet?.networks.first
    }
    
}
