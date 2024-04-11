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
        NavigationStack {
            if let selected = navigation.selected {
                WalletView(wallet: selected, showSettings: $navigation.showSettings, showWallets: $navigation.showWallets)
            } else if wallets.isEmpty {
                AddWalletView { wallet in
                    context.insert(wallet)
                    self.navigation.selected = wallet
                }
            }
        }
        .onAppear{
            navigation.select(from: wallets, lastSelected: lastSelected)
            priceModel.fetchPrices(coinIDs: coinIDs, currency: currency)
        }
        .sheet(isPresented: $navigation.showSettings) {

        }
        .sheet(isPresented: $navigation.showWallets) {
            NavigationStack {
                SelectWalletView()
                    .environment(walletManager)
            }
                .presentationDetents([.medium, .large])
        }
        .environment(walletManager)
        .environment(network)
        .environment(priceModel)
        .environment(navigation)
    }
    
}
