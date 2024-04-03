//
//  NetworkGridDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit
import BigInt

struct NetworkGridView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel
    
    let model: NetworkCard
    var color: Color { model.color }

    var price: Double? {
        priceModel.price(chain: model.chain, currency: currency)
    }
    
    var body: some View {
        Grid {
            GridRow {
                WalletAction.GridButton(.receive, card: model)
                WalletAction.GridButton(.send, card: model)
            }
            GridRow {
                VStack {
                    BalanceGridCell(balance: model.value, price: price)
                    TokensGridCell(model: model.tokenInfo)
                }
                NftGridCell(model: model.nftInfo, favorite: model.settings.coverNFT, color: color)
                    .environment(model)
            }
            GridRow {
                WalletAction.GridButton(.stake, card: model)
                WalletAction.GridButton(.swap, card: model)
            }
        }
        .environment(model)
        .networkTheme(card: model)
    }
}


import CardSpacing
#Preview {
    NavigationStack {
        ScrollView(.vertical, showsIndicators: false) {
            NetworkGridView(model: .ETH)
            .padding(.horizontal)
            .environmentPreview(.rifigy)
        }
        .background(Color.systemGray)
    }

}
