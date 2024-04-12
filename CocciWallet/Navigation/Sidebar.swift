//
//  Sidebar.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI

struct Sidebar: View {
    
    @Binding var wallet: Wallet?
    @Binding var selectedCard: EthereumNetworkCard?
    
    var body: some View {
        Group {
            #if os(iOS)
            if let wallet = navigation.selected {
                NetworkCardStack(wallet: wallet)
            } else {
                AddWalletView()
            }
            #else
            if let wallet {
                NetworkList(wallet: wallet, selectedCard: $selectedCard)
                    .navigationTitle("CocciWallet")
                    #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 200, ideal: 200)
                    #endif
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Button("", systemImage: "circle") {
            //                    showWallets = true
                            }
                        }
                    }
            }
            #endif
        }
//        .sheet(isPresented: $showWallets) {
//            
//        }

    }
}

//extension Sidebar where I == Panel, C == Label<Text, Image> {
//    init(selection: Binding<Panel?>) {
//        self._selected = selection
//        self.items = Panel.allCases
//        self.cell = { panel in
//            Label(panel.rawValue, systemImage: panel.image)
//        }
//    }
//}

enum Panel: String, Identifiable, CaseIterable, Hashable {
    var id: String { rawValue }
    case network, tokens, nfts, transactions
    
    var image: String {
        switch self {
//        case .wallets:
//            "triangle"
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
