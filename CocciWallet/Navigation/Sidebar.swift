//
//  Sidebar.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI

struct Sidebar: View {
    
    @Environment(Navigation.self) private var navigation
    
    @Binding var selection: Wallet?

    var body: some View {
        let showWallets = Bindable(navigation).showWallets
        
        Group {
            #if os(iOS)
            iosContent
            #else
            content
            #endif
        }
        .sheet(isPresented: showWallets) {
            NavigationStack {
                SelectWalletView(selected: $selection)
                    #if os(macOS)
                    .frame(minWidth: 300, minHeight: 250)
                    #endif
            }
        }
    }
    
    @ViewBuilder
    var iosContent: some View {
        if let selection {
            NetworkCardStack(wallet: selection)
        } else {
            AddWalletView()
        }
    }
    
    @ViewBuilder
    var content: some View {
        let showNewNetwork = Bindable(navigation).showNewNetwork
        if let wallet = selection {
            NetworkList(wallet: wallet)
                .navigationTitle(wallet.name)
                #if os(macOS)
                .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
                #endif
                .sheet(isPresented: showNewNetwork) {
                    AddNetworkView(address: wallet.address) { card in
                        if !wallet.networks.compactMap({$0.chain}).contains(card.chain) {
                            wallet.networks.append(card)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("Wallets", systemImage: "wallet.pass") {
                            self.navigation.showWallets = true
                        }
                    }
                }
                .navigationDestination(for: EthereumNetworkCard.self) { card in
                    NetworkDetailView(card: card)
                }
        }
    }
}


enum Panel: String, Identifiable, CaseIterable, Hashable {
    var id: String { rawValue }
    case network, tokens, nfts, transactions
    
    var image: String {
        switch self {
        case .network:
            "square"
        case .tokens:
            "circle"
        case .nfts:
            "circle"
        case .transactions:
            "circle"
        }
    }
}

//#Preview {
//    NavigationStack {
//        Sidebar(items: Panel.allCases, selected: .constant(nil)) {item in
//            Label(item.rawValue, systemImage: item.image)
//        }
//    }
//}
