//
//  Sidebar.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI


struct Sidebar: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    
    @Binding var wallet: Wallet?
    @Binding var network: Network?
    
    @Binding var showNewNetwork: Bool
    @Binding var showWallets: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        Group {
            #if os(iOS)
            iosContent
            #else
            content
            #endif
        }
        .onChange(of: network) {_, newValue in
            print("Sidebar \(newValue?.name ?? "null")")
        }

    }
    
    @ViewBuilder
    var iosContent: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content
        } else if let wallet {
            NetworkCardStack(
                wallet: wallet,
                selected: $network,
                showNewNetwork: $showNewNetwork,
                showWallets: $showWallets,
                showSettings: $showSettings
            )
        } else {
            AddWalletView {
                self.wallet = $0
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if let wallet {
            NetworkList(networks: wallet.networks, selected: $network, showNewNetwork: $showNewNetwork)
                .navigationTitle(wallet.name + wallet.networks.count.description)
                .sheet(isPresented: $showNewNetwork) {
                    AddNetworkView(wallet: wallet)
                }
        } else {
            ContentUnavailableView("Select a Wallet", systemImage: "triangle")
        }
    }
}


enum Panel: Hashable {
    case network, tokens, nfts, transactions, nft(String)
        
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
        case .nft( _):
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
