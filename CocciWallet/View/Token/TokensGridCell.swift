//
//  TokensGridCell.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/23/24.
//

import SwiftUI
import Web3Kit
import BigInt

struct TokensGridCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    @Environment(PriceModel.self) private var priceModel
    @Environment(\.networkTheme) private var networkTheme
    let model: TokenVM<EthClient.Client>
    
    var tokens: Int {
        model.balances.keys.count
    }

    var tokenValue: Double {
        model.totalValue(chain: networkTheme.chain, priceModel, currency: currency)
    }
    
    @State private var showTokens = false
    
    var body: some View {
        GridCell(
            title: "Tokens",
            balance: Double(tokens),
            value: tokenValue
        )
        .onTapGesture {
            self.showTokens = true
        }
        .navigationDestination(isPresented: $showTokens) {
            TokensListView(model: model, network: networkTheme.color, chain: networkTheme.chain)
                .navigationBarBackButton(nil, color: networkTheme.color)
        }
    }
}


#Preview {
    TokensGridCell(
        model: TokenVM<EthClient.Client>(address: Wallet.rifigy.address)
    )
    .preferredColorScheme(.dark)
    .environment(PriceModel.preview)
}

