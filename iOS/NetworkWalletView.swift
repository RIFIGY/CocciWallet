//
//  NetworkCardDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit

struct NetworkWalletView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel
    let card: NetworkCard
    
    @State private var showSettings = false
    
    var save: () -> Void
    var remove: () -> Void
    
    var body: some View {
        VStack {
            NetworkGridView(model: card)
            if !card.transactions.isEmpty, card.chain > 0 {
                DateTransactions(address: card.address, transactions: card.transactions, symbol: card.symbol)
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

        .sheet(isPresented: $showSettings, onDismiss: save ) {
            NavigationStack {
                NetworkCardSettings(card: card) {
                    remove()
                }
            }
        }
    }
    
    func price(_ card: NetworkCard) -> (Double, String)? {
        if let price = priceModel.price(chain: card.chain, currency: currency) {
            return (price, currency)
        } else {
            return nil
        }
    }
}


import CardSpacing
#Preview {
    NetworkWalletView(card: .ETH) {} remove: {}
        .environment(PriceModel.preview)
}

