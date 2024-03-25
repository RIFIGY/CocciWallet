//
//  NetworkCard.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI
import Web3Kit
import CardSpacing

struct NetworkCardView: View {
    @AppStorage("show_card_balance") private var showBalance = true
    let card: NetworkCard
    var price: (Double,String)?
    let animation: Namespace.ID
    
    var evm: EVM { card.evm }
    
    var balanceString: String {
        card.balance?.string(decimals: 5) ?? "00"
    }
    
    var symbol: String { evm.symbol ?? "generic" }
    
    var body: some View {
        CardView(color: evm.color) {
            HStack {
                IconView(symbol: symbol, size: 42, glyph: true)
                Text(card.name)
                    .bold()
                    .font(.title)
            }
                .foregroundStyle(.white)
        } topTrailing: {
            if let price {
                Text(price.0, format: .currency(code: price.1))
            } else if showBalance {
                Text(balanceString + (card.evm.symbol ?? ""))
            }
        } bottomLeading: {
            Text(card.address)
//                .font(.callout)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        } bottomTrailing: {
//            Text(card.address.shortened())
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.secondary, lineWidth: 0.8)
        )

    }
}

//#Preview {
//    NetworkCardView(card: .init(evm: .ETH, address: Wallet.rifigy.address, client: nil), price: (3462.42, "usd")) {
//        Text("Title")
//            .font(.title).bold()
//    }
//}
