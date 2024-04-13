//
//  DetailCollumn.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit
import SwiftData

struct DetailCollumn: View {
    @Environment(\.modelContext) private var context
    @Environment(Navigation.self) private var navigation
    
    @Binding var network: EthereumNetworkCard?
    
    
    var body: some View {
        Group {
            if let card = network  {
                NetworkDetailView(card: card)
                    .navigationDestination(for: NetworkCardDestination.self) { destination in
                        Group {
                            switch destination {
                            case .send:
                                Text("Send")
                            case .receive:
                                AddressView(address: card.address.string, name: card.name)
                            case .stake:
                                StakeView()
                            case .swap:
                                SwapView()
                            case .nft:
                                NFTGridView(nfts: card.nfts)
                            case .tokens:
                                TokensListView(network: card.color, address: card.address, balances: card.tokens, transfers: [ERC20Transfer]())
                            case .balance:
                                Text("Balance")
                            }
                        }
                        #if !os(tvOS)
                        .toolbarRole(.editor)
                        #endif
                    }
            } else {
                ContentUnavailableView("Select a Network", systemImage: "circle")
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
