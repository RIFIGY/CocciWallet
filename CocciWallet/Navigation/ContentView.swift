//
//  ContentView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import Web3Kit

struct ContentView: View {
    @AppStorage(AppStorageKeys.lastSelectedWallet) private var selectedWallet: String = ""
    @AppStorage(AppStorageKeys.lastSavedCoingeckoPlatforms) private var platformIds: String = "ethereum,bitcoin"
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCurrencies) private var currencies: String = "usd,ils,jpy"

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
            guard !selectedWallet.isEmpty else {return}
            walletManager.selected = walletManager.wallets.first{ $0.id == selectedWallet }
        }
        .task {
//            await priceModel.fetchPrices(platformIds: network.coingeckoIds )
            await priceModel.fetchPrices(platformIds: platformIds, currencies: currencies)
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                if let selected = walletManager.selected {
                    WalletSettingsView(wallet: selected)
                } else {
                    Text("Settings")
                }
            }
        }
        .environment(walletManager)
        .environment(network)
        .environment(priceModel)
    }
}


fileprivate func valueForAPIKey(named keyName: String) -> String {
    // Ensure the Secrets.plist file is part of the main bundle
    guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
        fatalError("Couldn't find file 'Secrets.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    
    let value = plist?.object(forKey: keyName) as? String
    
    return value!
//    if let value{
//        return value
//    } else {
//        fatalError("Unable to find key '\(keyName)' in 'Secrets.plist'.")
//    }
}

extension Etherscan {
    static var shared: Etherscan {
        let api = valueForAPIKey(named: "etherscan_api_key")
        return .init(api_key: api, cache: UserDefaults.standard)
    }
}

extension Infura {
    static var shared: Infura {
        let api = valueForAPIKey(named: "infura_api_key")
        return .init(api_key: api, session: .shared)
    }
}
