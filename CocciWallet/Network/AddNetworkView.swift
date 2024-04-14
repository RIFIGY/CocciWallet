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
    @Environment(\.modelContext) private var context
    @Environment(Prices.self) private var prices
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCoins) private var coinIds = "ethereum"

    @Bindable var wallet: Wallet
    var network: (EthereumNetworkCard) -> Void
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(EthereumCardEntity.selection) { evm in
                    HStack{
                        IconImage(symbol: evm.symbol, glyph: .white)
                        Button(evm.name) {
                            add(evm: evm)
                        }
                        .foregroundStyle(Color(hex: evm.color) ?? .ETH)
                    }
                }

                Section {
                    NavigationLink {
                        AddCustomNetworkView(wallet: wallet) { evm in
                            network(evm)
                            dismiss()
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
    }

    func add(evm: EthereumCardEntity) {
        let card = EthereumNetworkCard(wallet: wallet, chain: evm.chain, rpc: evm.rpc, name: evm.name, symbol: evm.symbol, hexColor: evm.color)
        context.insert(card)
        wallet.networks.append(card)
        add(network: card)
    }
    
    func add(network: EthereumNetworkCard) {
        if let coin = CoinGecko.AssetPlatform.NativeCoin(chainID: network.chain) {
            var ids = self.coinIds
            guard !ids.contains(coin) else {return}
            self.coinIds = ids + ",coin"
            prices.fetch(coin: coin, currency: currency)

        }
        self.network(network)
        dismiss()
    }
}



//#Preview {
//    AddNetworkView(address: .rifigy){ _ in}
//        .environmentPreview()
//}
