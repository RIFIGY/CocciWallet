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

    @Environment(\.modelContext) private var context
    @Query private var wallets: [Wallet]
    
    @State private var navigation = Navigation()
    
    @State private var walletManager = WalletHolder()
    @State private var network = NetworkManager()
    @State private var priceModel = PriceModel()
    
    var body: some View {
        NavigationSplitView {
            if let selected = navigation.selected {
                WalletView(wallet: selected)
            }
        } detail: {
            NavigationStack {
                if let selected = navigation.selectedNetwork {
                    NetworkDetailView(card: selected)
                        .environment(walletManager)
                        .environment(network)
                        .environment(priceModel)
                        .environment(navigation)
                } else if self.wallets.isEmpty || self.navigation.selected == nil {
                    AddWalletView { wallet in
                        context.insert(wallet)
                        self.navigation.selected = wallet
                    }
                }
            }
        }
        .sheet(isPresented: $navigation.showWallets) {
            NavigationStack {
                SelectWalletView()
                    .environment(walletManager)
            }
                .presentationDetents([.medium, .large])
        }
        .onAppear{
            navigation.select(from: wallets, lastSelected: lastSelected)
            priceModel.fetchPrices(coinIDs: coinIDs, currency: currency)
        }
//        .onChange(of: selection) { _ in
//            path.removeLast(path.count)
//        }
        .environment(walletManager)
        .environment(network)
        .environment(priceModel)
        .environment(navigation)
//        .environmentObject(accountStore)
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
        .frame(maxWidth: 800, maxHeight: 700)
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
//        .onAppear{
//            navigation.select(from: wallets, lastSelected: lastSelected)
//            priceModel.fetchPrices(coinIDs: coinIDs, currency: currency)
//        }
//        .sheet(isPresented: $navigation.showSettings) {
//
//        }

    
}
