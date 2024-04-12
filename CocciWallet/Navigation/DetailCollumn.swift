//
//  DetailCollumn.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit
struct DetailCollumn: View {
    
    @Environment(Navigation.self) private var navigation
    
    @Binding var wallet: Wallet?
    
    
    var body: some View {
        Group {
            if let wallet {
                if let card = navigation.selectedNetwork {
                    NetworkDetailView(card: card)
                } else {
                    ContentUnavailableView("Add or select a network", systemImage: "circle")
                }
            } else {
                AddWalletView()

            }

        }

    }
//    let detail: Panel = .network

//    switch detail {
//    case .network:
//       NetworkDetailView(card: card)
//    case .tokens:
//        TokensListView(network: card.color, address: card.address, balances: card.tokens, transfers: [ERC20Transfer]())
//    case .nfts:
//        Text("NFTs")
////                        NFTGridView(nfts: card.nfts)
//    case .transactions:
//        DateTransactions(address: card.address.string, transactions: card.transactions)
//    }
}

//#Preview {
//    DetailCollumn(panel: .constant(.networks))
//}