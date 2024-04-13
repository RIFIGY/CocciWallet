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
    
    @Query private var wallets: [Wallet]
    
    @State var path = NavigationPath()

    @State private var navigation = Navigation()
    @State private var network = NetworkManager()
    @State private var prices = Prices()
    
    @State private var selection: Panel? = Panel.network
    
    @State private var selected: Wallet?
    @State private var selectedNetwork: EthereumNetworkCard?
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            if let selected {
                Sidebar(wallet: selected, selected: $selectedNetwork)
            } else if !wallets.isEmpty {
                SelectWalletView(selected: $selected)
            } else {
                AddWalletView()
            }

        } detail: {
            if let selected {
                NavigationStack(path: $path) {
                    DetailCollumn(network: $selectedNetwork)
                }
            } else {
                ContentUnavailableView("Select a Wallet", systemImage: "circle")
            }
        }
        .onAppear{
            self.selected = wallets.first
            self.selectedNetwork = self.selected?.networks.first
        }
        .onChange(of: selected) { oldValue, _ in
            path.removeLast(path.count)
            if oldValue != nil {
                self.selectedNetwork = nil
            }
        }
        .onChange(of: selectedNetwork) { _, _ in
            path.removeLast(path.count)
        }
        .environment(network)
        .environment(prices)
        .environment(navigation)
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
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
