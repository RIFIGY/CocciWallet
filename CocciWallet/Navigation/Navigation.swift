//
//  Navigation.swift
//  CocciWallet
//
//  Created by Michael on 4/10/24.
//

import Foundation
import WalletData
import SwiftUI

@Observable
class Navigation {
    
//    var selected: Wallet?
    var selectedNetwork: EthereumNetworkCard?
    
    var showNewNetwork = false
    var showSettings = false
    var showNetworkSettings = false
    var showWallets = false
    
        
    
    func select(from wallets: [Wallet], lastSelected: String) {
        
        let wallet: Wallet?
        
        if lastSelected.isEmpty {
            wallet = wallets.first
        } else {
            wallet = wallets.first{$0.id == lastSelected}
        }
        print("Selecting \(wallet?.name ?? "None")")
//        self.selected = wallet
//        self.selectedNetwork = wallet?.networks.last
    }
    
//    func select(wallet: Wallet) {
//        guard self.selected != wallet else {return}
//        self.selected = wallet
//    }
//    
//    func deleted(wallet: Wallet, in wallets: [Wallet]) {
//        self.selected = wallets.first{$0 != wallet}
//    }
}
