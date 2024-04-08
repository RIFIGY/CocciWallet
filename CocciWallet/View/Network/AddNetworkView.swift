//
//  AddNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import Web3Kit
import OffChainKit

struct AddNetworkView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCoins) private var coinIDs: String = "ethereum"

    @Environment(NetworkManager.self) private var networkManager
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var wallet: Wallet
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(EthereumNetwork.selection) { evm in
                    let color = Color(hex: evm.hexColor) ?? .ETH
                    HStack{
                        IconImage(symbol: evm.symbol, glyph: .white)
                        Button(evm.name) {
                            add(evm, false)
                        }
                        .foregroundStyle(Color(hex: evm.hexColor) ?? .ETH)
                    }
                }

                Section {
                    NavigationLink {
                        AddCustomNetworkView { evm in
                            add(evm, true)
                        }
                    } label: {
                        HStack{
    //                        IconView(symbol: "generic", size: 25, glyph: true)
                            Text("Custom Network")
                                .foregroundStyle(Color.ETH)
                        }
                    }
                    Button("Local"){
                        add(.custom, true)
                    }
                }
            }
        }
    }

    func add(_ evm: EthereumNetwork, _ isCustom: Bool) {
        let network = NetworkCard(evm: evm, address: wallet.address)
        
        let cards = wallet.cards + wallet.custom
        guard !cards.contains(where: {$0.chain == network.chain})
        else {return}
        wallet.add(network)
        
        if let coingeckoID = CoinGecko.AssetPlatform.NativeCoin(chainID: evm.chain) {
            guard !self.coinIDs.contains(coingeckoID) else {return}
            self.coinIDs = self.coinIDs + ",\(coingeckoID)"
        }
        dismiss()
    }
    
    func add(blockchain: Blockchain) {}
}

fileprivate extension EthereumNetwork {
    static var custom: EthereumNetwork {
        .init(rpc: URL(string: "HTTP://127.0.0.1:7545")!, chain: 1337, name: "Ganache", symbol: "TEST", explorer: "etherscan.io", hexColor: nil, isCustom: true)
    }
}


#Preview {
    AddNetworkView(wallet: .rifigy)
        .environment(NetworkManager())
        .environment(PriceModel.preview)
        .environment(Wallet.rifigy)
}

#Preview {
    Image(systemName: "a")
}
