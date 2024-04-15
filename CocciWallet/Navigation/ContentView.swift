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
import OSLog

struct ContentView: View {
    @AppStorage(AppStorageKeys.lastSelectedWallet) private var lastSelected: String = ""
    
    @Query private var wallets: [Wallet]

    @State private var navigation = Navigation()
    @State private var networks = NetworkManager()
    @State private var prices = Prices()
    

    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            if let wallet = wallets.first {
                Sidebar(
                    wallet: wallet
                )
            }
        } detail: {
            NavigationStack(path: $navigation.path) {
                DetailCollumn(
                    walletSelected: navigation.wallet != nil,
                    selected: $navigation.network
                )
            }
        }
//        .onAppear{
//            if !lastSelected.isEmpty {
//                navigation.select(wallets.first{ $0.id == lastSelected }  )
//            } else {
//                navigation.select(wallets.first)
//            }
//        }
//        .onChange(of: navigation.wallet) { oldValue, _ in
//            navigation.clearPath()
//            if oldValue != nil {
//                navigation.network = nil
//            }
//        }
//        .onChange(of: navigation.network) { _, _ in
//            navigation.clearPath()
//        }
        .environment(networks)
        .environment(prices)
        .environment(navigation)
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
        #elseif os(iOS)
        .onOpenURL(perform: navigation.onOpenURL)
        #endif
    }

    
}
