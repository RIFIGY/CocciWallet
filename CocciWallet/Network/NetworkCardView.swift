//
//  NetworkCard.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI
import Web3Kit
import CardSpacing
import OffChainKit

struct NetworkCardView: View {
    @AppStorage(AppStorageKeys.showNetworkPriceHeader) private var showPrice = true
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    
    let animation: Namespace.ID
    let title: String
    let symbol: String
    
    let address: String

    let color: Color
    var price: Double?
    let balanceString: String
    

    var body: some View {
        CardView(color: color) {
            HStack {
                IconView(symbol: symbol, size: 42, glyph: .white)
                Text(title)
                    .bold()
                    .font(.title)
            }
                .foregroundStyle(.white)
        } topTrailing: {
            Group {
                if let price, showPrice {
                    Text(price, format: .currency(code: currency))
                } else if !showPrice {
                    Text(balanceString + " " + symbol)
                }
            }
            .foregroundStyle(.white)
        } bottomLeading: {

        } bottomTrailing: {
            Text(address.shortened())
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.secondary, lineWidth: 0.8)
        )

    }
}

extension NetworkCardView {
    init(card: EthereumNetworkCard, price: Double? = nil, animation: Namespace.ID) {
        self.title = card.name
        self.price = price
        self.color = card.color
        self.address = card.address.string
        self.balanceString = card.value?.string(decimals: 5) ?? "00"
        self.symbol = card.symbol
        self.animation = animation
    }
    
}


#Preview {
    NetworkCardView(
        card: .preview,
        price: 3254.32,
        animation: Namespace().wrappedValue
    )
    .frame(height: 200)
    .padding(.horizontal)
}
