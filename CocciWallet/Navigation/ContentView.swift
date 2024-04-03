//
//  ContentView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import Web3Kit
import OffChainKit

struct ContentView: View {
    @AppStorage(AppStorageKeys.lastSelectedWallet) private var selectedWallet: String = ""
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCoins) private var coinIDs: String = "ethereum"

    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"

    @State private var walletManager = WalletHolder()
    @State private var network = NetworkManager()
    @State private var priceModel = PriceModel()
    
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            if let selected = walletManager.selected {
                WalletView(wallet: selected, showSettings: $showSettings)
            } else if walletManager.wallets.isEmpty {
                AddWalletView { wallet in
                    walletManager.add(wallet: wallet)
                }
            }
        }
        .onAppear{
            walletManager.select(id: selectedWallet)
        }
        .task {
            print("CoinIDS:" + coinIDs)
            let ids = coinIDs.components(separatedBy: ",")
            await priceModel.fetchPrices(coinIDs: ids, currency: currency)
        }
        .sheet(isPresented: $showSettings, onDismiss: save) {
            NavigationStack {
                if let selected = walletManager.selected {
                    WalletSettingsView(wallet: selected)
                } else {
                    Form {
                        AppSettings()
                    }
                }
            }
        }
        .environment(walletManager)
        .environment(network)
        .environment(priceModel)
    }
    
    private func save(){
        if let selected = walletManager.selected {
            selected.save()
        }
    }
}
