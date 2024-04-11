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
//    let tokens: Tokens
    let balances: [ERC20 : BigUInt]
    var transfers: [ERC20Transfer]

    let address: EthereumAddress
    var totalTokens: Int {
        balances.keys.count
    }

    var tokenValue: Double {
        balances.reduce(into: 0.0) { total, entry in
            let (contract, balance) = entry
            let price = priceModel.price(contract: contract.contract.string, currency: currency)
            let value = balance.value(decimals: contract.decimals) * (price ?? 0)
            total += value
        }
    }
    
    @State private var showTokens = false
    
    var body: some View {
        GridCell(
            title: "Tokens",
            balance: Double(totalTokens),
            value: tokenValue
        )
        .onTapGesture {
            self.showTokens = true
        }
        .navigationDestination(isPresented: $showTokens) {
            TokensListView(network: networkTheme.color, address: address, balances: balances, transfers: transfers)
//                .navigationBarBackButton(nil, color: networkTheme.color)
        }
    }
}


//#Preview {
//    TokensGridCell(
//        tokens: Tokens.preview,
//        address: .init(Wallet.rifigy.address.string)
//    )
//    .preferredColorScheme(.dark)
//    .environment(PriceModel.preview)
//}
//
