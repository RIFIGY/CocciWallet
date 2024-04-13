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
    let address: Web3Kit.EthereumAddress
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
                        AddCustomNetworkView(address: address) { evm in
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
        let card = EthereumNetworkCard(address: address, chain: evm.chain, rpc: evm.rpc, name: evm.name, symbol: evm.symbol, hexColor: evm.color)
        add(network: card)
    }
    
    func add(network: EthereumNetworkCard) {
        self.network(network)
        dismiss()
    }
}



//#Preview {
//    AddNetworkView(address: .rifigy){ _ in}
//        .environmentPreview()
//}
