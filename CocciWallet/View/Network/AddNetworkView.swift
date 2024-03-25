//
//  AddNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import Web3Kit

struct AddNetworkView: View {
    @AppStorage("currency") private var currency: String = "usd"
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    @Environment(WalletModel.self) private var wallet
    
    @Binding var showNewNetwork: Bool
    
    var body: some View {
        List {
            ForEach(EVM.selection) { evm in
                HStack{
                    IconView(symbol: evm.symbol ?? "generic", size: 25, glyph: true)
                    Button(evm.name ?? evm.chain.description) {
                        add(evm: evm, custom: false)
                    }
                    .foregroundStyle(evm.color)
                }
            }

            Section {
                NavigationLink {
                    CustomNetworkView { evm in
                        add(evm: evm, custom: true)
                    }
                } label: {
                    HStack{
//                        IconView(symbol: "generic", size: 25, glyph: true)
                        Text("Custom Network")
                            .foregroundStyle(Color.ETH)
                    }
                }
            }
        }
    }
    
    func add(evm: EVM, custom: Bool) {
        wallet.add(evm, custom: custom)
        network.add(evm: evm)
        self.showNewNetwork = false
        Task {
            await priceModel.fetchPrice(for: evm, currency: currency)
        }
    }
}



#Preview {
    AddNetworkView(showNewNetwork: .constant(false))
        .environment(NetworkManager())
        .environment(PriceModel.preview)
        .environment(WalletModel(.rifigy))
}
