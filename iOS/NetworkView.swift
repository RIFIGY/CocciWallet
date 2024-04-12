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
    
    var value: Double? {
        guard let balance = card.value, let price else {return nil}
        return balance * price
    }
    
    @State private var destination: NetworkCardDestination?

    var body: some View {
        NetworkGrid(card: card)
            .foregroundStyle(.primary)
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

