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
    @Environment(PriceModel.self) private var prices

    let title: String
    let symbol: String
    
    let address: String
    let chain: Int
    let color: Color
    var price: Double? {
        prices.price(chain: chain, currency: currency)
    }
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
    init(card: Network) {
        self.title = card.name
        self.color = card.color
        self.chain = card.chain
        self.address = card.address.string
        self.balanceString = card.balance?.string(decimals: 5) ?? "00"
        self.symbol = card.symbol
    }
    
    init(entity: NetworkEntity) {
        self.title = entity.title
        self.symbol = entity.symbol
        self.chain = entity.chain
        self.color = Color(hex: entity.hexColor) ?? .indigo
        self.address = entity.rpc.absoluteString
        self.balanceString = "-00-"
    }
    
}


#Preview {
    NetworkCardView(
        card: .preview
    )
    .frame(height: 200)
    .padding(.horizontal)
}
