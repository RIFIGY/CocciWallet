//
//  NetworkCardDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit

struct NetworkWalletView: View {
    @AppStorage("currency") var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel

    let card: NetworkCard
    
    
    @State private var showToolbar: (Bool, CGFloat) = (false,0)

    var body: some View {
        VStack {
            NetworkGridView(model: card)
            if !card.transactions.isEmpty, card.evm.chain > 0 {
                DateTransactions(model: .init(address: card.address, price: price(card.evm), evm: card.evm ), transactions: card.transactions)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Test"){print("Detail")}
                    .foregroundStyle(card.evm.color)
            }

        }
    }
    
    func price(_ evm: EVM) -> (Double, String)? {
        priceModel.price(evm: evm, currency: currency)
    }

}

import CardSpacing
#Preview {
    NetworkWalletView(card: .ETH)
        .environment(PriceModel.preview)
}
