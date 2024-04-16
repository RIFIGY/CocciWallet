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
    @Environment(\.modelContext) private var context
    @Query private var wallets: [Wallet]

    @State private var prices = Prices()

    @State private var wallet: Wallet?
    @State private var network: Network?
    
    @State private var showWallets = false
    @State private var showNewNetwork = false
    @State private var showSettings = false
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var path = NavigationPath()
    var hasWallet: Bool { wallet != nil }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Sidebar(
                wallet: $wallet,
                network: $network,
                showNewNetwork: $showNewNetwork,
                showWallets: $showWallets,
                showSettings: $showSettings
            )
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
            #endif
            .toolbar {
                ToolbarItem {
                    Button("Wallets", systemImage: "wallet.pass") {
                        showWallets = true
                    }
                }
                ToolbarItem {
                    Button("Settings", systemImage: "gearshape") {
                        showSettings = true
                    }
                }
            }
        } detail: {
            NavigationStack(path: $path) {
                DetailCollumn(selected: $network)
            }
//            ContentUnavailableView(
//                "Select a \(hasWallet ? "Network" : "Wallet")",
//                systemImage: hasWallet ? "circle" : "triangle"
//            )
//            NavigationStack(path: $path) {
//                DetailCollumn(
//                    wallet: wallet,
//                    network: $network
//                )
//            }
        }
        .environment(prices)
        .sheet(isPresented: $showWallets) {
            NavigationStack {
                SelectWalletView(selected: $wallet)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(selection: $wallet)
        }
        .onAppear {
            self.wallet = wallets.first
            #if !os(iOS)
            self.network = self.wallet?.networks.first
            #endif
        }
        .onChange(of: network) { oldValue, newValue in
            path.removeLast(path.count)
        }
        .onChange(of: wallet) { oldValue, newValue in
            path.removeLast(path.count)

//            navigation.clearPath()
            if oldValue != nil {
                network = nil
            }
            Task {
                await newValue?.updateCards(context: context)
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

        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
        #elseif os(iOS)
//        .onOpenURL(perform: navigation.onOpenURL)
        #endif
    }

    
}
