//
//  DetailCollumn.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit
struct DetailCollumn: View {
    
    
    let wallet: Wallet
    @Binding var selected: EthereumNetworkCard?
    
    var body: some View {
        Group {
            if let selected {
                NetworkDetailView(card: selected)
            } else {
                ContentUnavailableView("Choose a Network", systemImage: "circle")
            }
        }
        
//        switch panel ?? .network {
////            case .wallets:
////                SelectWalletView()
//            case .network:
////                Collumn { card in
////                    NetworkDetailView(card: card)
////                }
//                if let network = selected {
//                    NetworkDetailView(card: network)
//                } else {
//                    ContentUnavailableView("Add or select a network", systemImage: "circle")
//                }
//            case .tokens:
//                Collumn { card in
//                    TokensListView(network: card.color, address: card.address, balances: card.tokens, transfers: [ERC20Transfer]())
//                }
//            case .nfts:
//                Collumn { card in
////                    NFTGridView(nfts: )
//                }
//            case .transactions:
//                Collumn { card in
////                    NFTGridView(nfts: )
//                }
//        }
    }
    
    @ViewBuilder
    private func Collumn(@ViewBuilder content: (EthereumNetworkCard) -> some View) -> some View {
        if let network = selected {
            content(network)
        } else {
            ContentUnavailableView("Add or select a network", systemImage: "circle")
        }
    }
}

//#Preview {
//    DetailCollumn(panel: .constant(.networks))
//}
