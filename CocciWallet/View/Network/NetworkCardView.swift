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
    let card: NetworkCard
    var price: Double?
    let animation: Namespace.ID
    
    var color: Color { card.color }
    
    var balanceString: String {
        card.value?.string(decimals: 5) ?? "00"
    }
    
    var symbol: String { card.symbol ?? "generic" }
    
    var body: some View {
        CardView(color: color) {
            HStack {
//                IconView(symbol: symbol, size: 42, glyph: true)
                Text(card.title)
                    .bold()
                    .font(.title)
            }
                .foregroundStyle(.white)
        } topTrailing: {
            Group {
                if let price, showPrice {
                    Text(price, format: .currency(code: currency))
                } else if !showPrice {
                    Text(balanceString + " " + (card.symbol ?? ""))
                }
            }
            .foregroundStyle(.white)
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

struct BlockchainCardView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    @AppStorage("show_card_balance") private var showBalance = true
    @Environment(PriceModel.self) private var priceModel
    let chain: Blockchain
    
    var price: Double? {
        priceModel.price(coin: chain.name.lowercased(), currency: currency)
    }
    
    var body: some View {
        CardView(color: chain.color) {
            HStack {
                IconView(symbol: chain.crypto.symbol, size: 42, glyph: .white)
                Text(chain.name)
                    .bold()
                    .font(.title)
            }
                .foregroundStyle(.white)
        } topTrailing: {
            Group {
                if let price {
                    Text(price, format: .currency(code: currency))
                }
            }
            .foregroundStyle(.white)
        } bottomLeading: {
            
        } bottomTrailing: {
            
        }
        
    }
}

//#Preview {
//    NetworkCardView(card: .init(evm: .ETH, address: Wallet.rifigy.address, client: nil), price: (3462.42, "usd")) {
//        Text("Title")
//            .font(.title).bold()
//    }
//}
