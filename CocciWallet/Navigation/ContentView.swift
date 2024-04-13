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
    
    @State var path = NavigationPath()

    @State private var navigation = Navigation()
    @State private var network = NetworkManager()
    @State private var prices = Prices()
    
    @State private var selection: Panel? = Panel.network
    
    @State private var selected: Wallet?
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
//            if let first = wallets.first {
//                Sidebar(wallet: first)
//            } else if !wallets.isEmpty {
////                SelectWalletView(selected: $selected)
//            } else {
//                AddWalletView()
//            }
            if let selected {
                Sidebar(wallet: selected)
            }

        } detail: {
//            NavigationStack(path: $path) {
//                DetailCollumn(wallet: $selected)
//            }
            ContentUnavailableView("Select a Network", systemImage: "circle")
        }
        .onAppear{
            self.selected = wallets.first
        }
        
//        .onChange(of: selected) { _, _ in
//            print(path)
//            path.removeLast(path.count)
//            self.navigation.selectedNetwork = nil
//            print(path)
//        }

        .environment(network)
        .environment(prices)
        .environment(navigation)
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
//        .frame(maxWidth: 800, maxHeight: 700)
        #elseif os(iOS)
        .onOpenURL { url in
//            let urlLogger = Logger(subsystem: "app.rifigy.CocciWallet", category: "url")
//            urlLogger.log("Received URL: \(url, privacy: .public)")
            let nft = "#\(url.lastPathComponent)"
            var newPath = NavigationPath()
//            selection = Panel.truck
//            Task {
//                newPath.append(Panel.orders)
//                newPath.append(order)
//                path = newPath
//            }
        }
        #endif
    }

    
}
