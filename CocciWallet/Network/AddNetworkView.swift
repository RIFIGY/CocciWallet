//
//  AddNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import Web3Kit
import OffChainKit
import SwiftData

struct AddNetworkView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCoins) private var coinIds = "ethereum"
    
    @Environment(\.modelContext) private var context
    @Environment(Prices.self) private var prices

    @Bindable var wallet: Wallet
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        List {
            ForEach(NetworkEntity.selection) { evm in
                HStack{
                    IconImage(symbol: evm.symbol, glyph: .white)
                    Button(evm.name) {
                        add(evm: evm)
                    }
                    .foregroundStyle(Color(hex: evm.hexColor) ?? .ETH)
                }
            }

            Section {
                NavigationLink {
                    AddCustomNetworkView { evm in
                        add(evm: evm)
                    }
                } label: {
                    HStack{
//                        IconView(symbol: "generic", size: 25, glyph: true)
                        Text("Custom Network")
                            .foregroundStyle(Color.ETH)
                    }
                }
                Button("Local"){
                    add(evm: .Local())
                }
            }
        }
    }

    func add(evm: NetworkEntity) {
        guard !wallet.networks.map({$0.chain}).contains(evm.chain) else {return}
        let network = Network(address: wallet.string, card: evm, settings: .init())
        withAnimation {
            context.insert(network)
            wallet.networks.append(network)
        }
        if let coin = CoinGecko.AssetPlatform.NativeCoin(chainID: network.chain) {
            var ids = self.coinIds
            guard !ids.contains(coin) else {return}
            self.coinIds = ids + ",coin"
            prices.fetch(coin: coin, currency: currency)

        }
        dismiss()

    }

}



//#Preview {
//    AddNetworkView(address: .rifigy){ _ in}
//        .environmentPreview()
//}
