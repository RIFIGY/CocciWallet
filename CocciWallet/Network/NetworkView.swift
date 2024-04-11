//
//  NetworkCardDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit

struct NetworkView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var card: EthereumNetworkCard
    var address: EthereumAddress { card.address }
    
    @State private var showSettings = false
    
    var remove: () -> Void
    
    var price: Double? {
        return priceModel.price(chain: card.chain, currency: currency)
    }
    
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    WalletAction.GridButton(.receive, card: card)
                    WalletAction.GridButton(.send, card: card)
                }
                GridRow {
                    VStack {
                        BalanceGridCell(balance: card.value, price: price)
                        TokensGridCell(balances: card.tokens, transfers: [], address: card.address)
                    }
                    NftGridCell(nfts: card.nfts, address: address, favorite: nil, color: card.color)
                        .environment(card)
                }
                GridRow {
                    WalletAction.GridButton(.stake, card: card)
                    WalletAction.GridButton(.swap, card: card)
                }
            }
            .environment(card)
            .networkTheme(card: card)
            if !card.transactions.isEmpty, card.chain > 0 {
                DateTransactions(address: address.string, transactions: card.transactions, symbol: card.symbol)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(systemName: "gearshape"){
                    showSettings = true
                }
                .foregroundStyle(card.color)
            }
        }

        .sheet(isPresented: $showSettings) {
            NavigationStack {
                NetworkCardSettings(card: card) {
                    remove()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            NetworkCardView(card: .preview, animation: Namespace().wrappedValue)
                .frame(height: 200)
                .padding(.horizontal)
            NetworkView(card: .preview){}
                .padding(.horizontal)
        }
        .background(Color.systemGray)
    }
    .environmentPreview()
}

