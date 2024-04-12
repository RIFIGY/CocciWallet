//
//  ContentView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import Web3Kit
import OffChainKit
import SwiftData

struct ContentView: View {
    @AppStorage(AppStorageKeys.lastSelectedWallet) private var lastSelected: String = ""
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCoins) private var coinIDs: String = "ethereum"

    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    
    @Query private var wallets: [Wallet]
    
    @State private var navigation = Navigation()
    @State private var network = NetworkManager()
    @State private var prices = Prices()
    
    @State private var selection: Panel? = Panel.network

    
    var body: some View {
        NavigationSplitView {
            Sidebar(wallet: $navigation.selected, selectedCard: $navigation.selectedNetwork)
        } detail: {
            if let wallet = navigation.selected {
                NavigationStack {
                    DetailCollumn(wallet: wallet, selected: $navigation.selectedNetwork)
                }
            } else {
                AddWalletView()
            }
        }
        .onAppear{
            navigation.select(from: wallets, lastSelected: lastSelected)
            prices.fetch(coinIDs: coinIDs, currency: currency)
        }
        .environment(network)
        .environment(prices)
        .environment(navigation)
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
//        .frame(maxWidth: 800, maxHeight: 700)
        #elseif os(iOS)

//        .onOpenURL { url in
//            let urlLogger = Logger(subsystem: "com.example.apple-samplecode.Food-Truck", category: "url")
//            urlLogger.log("Received URL: \(url, privacy: .public)")
//            let order = "Order#\(url.lastPathComponent)"
//            var newPath = NavigationPath()
//            selection = Panel.truck
//            Task {
//                newPath.append(Panel.orders)
//                newPath.append(order)
//                path = newPath
//            }
//        }
        #endif
    }

    
}
