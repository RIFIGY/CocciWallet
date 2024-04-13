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
    @Bindable var wallet: Wallet

    var body: some View {
        Group {
            #if os(iOS)
            iosContent
            #else
            content
            #endif
        }
//        .sheet(isPresented: navigation.showWallets) {
//            NavigationStack {
//                SelectWalletView(selected: $selection)
//                    #if os(macOS)
//                    .frame(minWidth: 300, minHeight: 250)
//                    #endif
//            }
//        }
//        .sheet(isPresented: navigation.showSettings) {
//            SettingsView(selection: $selection)
//        }
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
        NetworkList(address: wallet.address, networks: $wallet.networks, settings: wallet.settings)
            .navigationTitle(wallet.name)
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
            #endif
            .task {
                
            }

//            .toolbar {
//                ToolbarItem(placement: .automatic) {
//                    Button("Wallets", systemImage: "wallet.pass") {
//                        self.navigation.showWallets = true
//                    }
//                }
//                ToolbarItem(placement: .automatic) {
//                    Button("Settings", systemImage: "gearshape") {
//                        self.navigation.showSettings = true
//                    }
//                }
//            }
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
