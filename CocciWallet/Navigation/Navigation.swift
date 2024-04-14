//
//  Navigation.swift
//  CocciWallet
//
//  Created by Michael on 4/10/24.
//

import Foundation
import WalletData
import SwiftUI
import OSLog

@Observable
class Navigation {
    private let logger = Logger(subsystem: "app.rifigy.CocciWallet.Navigation", category: "navigation")
    var wallet: Wallet?
    var network: EthereumNetworkCard?
    
    
    var panel: Panel? = Panel.network

    var path = NavigationPath()

    
    var showNewNetwork = false
    var showSettings = false
    var showNetworkSettings = false
    var showWallets = false
    
    
    func clearPath(count: Int? = nil) {
        path.removeLast(count ?? path.count)
    }
    
    func select(_ wallet: Wallet?) {
        withAnimation {
            self.wallet = wallet
            self.network = wallet?.networks.first
        }
    }
    
    func select(_ network: EthereumNetworkCard?) {
        withAnimation {
            self.network = network
        }
    }
    
    func onOpenURL(_ url: URL) {
        logger.log("Received URL: \(url, privacy: .public)")
        
        let nft = "\(url.lastPathComponent)"
        
        let contract = "contract"
        self.panel = Panel.nft("contract")
        Task {
            var newPath = NavigationPath()

            newPath.append(Panel.nfts)
            newPath.append(nft)
            path = newPath
        }
    }
}
