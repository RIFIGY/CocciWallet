//
//  Sidebar.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI


struct Sidebar: View {
    @Environment(Navigation.self) private var navigation
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    
    @Bindable var wallet: Wallet
//    @Binding var selected: Network?

    var body: some View {
        let navigation = Bindable(navigation)
        Group {
            #if os(iOS)
            iosContent
            #else
            content
            #endif
        }
        .sheet(isPresented: navigation.showWallets) {
            NavigationStack {
                SelectWalletView(selected: navigation.wallet)
            }
        }
        .sheet(isPresented: navigation.showSettings) {
            SettingsView(selection: navigation.wallet)
        }
        .sheet(isPresented: navigation.showNewNetwork) {
            AddNetworkView(wallet: wallet)
        }

    }
    
    @ViewBuilder
    var iosContent: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content
        } else {
            NetworkCardStack(wallet: wallet)
        }
    }
    
    @ViewBuilder
    var content: some View {
        let navigation = Bindable(navigation)

        NetworkList(networks: wallet.networks, showNewNetwork: navigation.showNewNetwork)
            .navigationTitle(wallet.name + wallet.networks.count.description)
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Wallets", systemImage: "wallet.pass") {
                        self.navigation.showWallets = true
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button("Settings", systemImage: "gearshape") {
                        self.navigation.showSettings = true
                    }
                }
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
