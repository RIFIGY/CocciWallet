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
    @Environment(PriceModel.self) private var priceModel

    let evm: EVM
    var tokenBalances: [ERC20 : BigUInt] = [:]
    var tokenTransfers: [ERC20 : [ERC20Transfer] ] = [:]

    var tokens: Int { tokenBalances.keys.count }

    var tokenValue: Double {
        tokenBalances.compactMap { contract, balance in
            let value = balance.value(decimals: contract.decimals)
            let price = priceModel.price(evm: evm, contract: contract.contract)
            if let price = price?.0 {
                return price * value
            } else {
                return nil
            }
        }
        .reduce(0, +)
    }
    
    @State private var showTokens = false
    
    var body: some View {
        NetworkGridCell(
            title: "Tokens",
            balance: Double(tokens),
            value: tokenValue
        )
        .onTapGesture {
            self.showTokens = true
        }
        .fullScreenCover(isPresented: $showTokens) {
                NavigationStack {
                    ERC20View(evm: evm, balances: tokenBalances, transfers: tokenTransfers)
                }
            }
    }
}

struct NativeBalanceGridCell: View {
    @Environment(PriceModel.self) private var priceModel

    let evm: EVM
    let balance: Double?
    
    var price: (Double, String)? {
        priceModel.price(evm: evm)
    }
    
    var value: Double? {
        guard let balance, let price = price?.0 else {return nil}
        return balance * price
    }
    
    @State private var showBalance = false
    
    var body: some View {
        NetworkGridCell(title: "Balance", balance: balance, value: value)
            .onTapGesture {
                showBalance = true
            }
            .fullScreenCover(isPresented: $showBalance) {
                NavigationStack {
                    Text("Balance")
                        #if !os(tvOS)
                        .toolbarRole(.editor)
                        #endif
                        .toolbar {
                            ToolbarItem(placement: .automatic) {
                                Button("Test"){}
                            }
                        }
                }
            }
    }
}

#Preview {
    TokensGridCell(
        evm: .ETH,
        tokenBalances: [ERC20.USDC : .init(integerLiteral: 44000000)]
    )
    .preferredColorScheme(.dark)
    .environment(PriceModel.preview)
}

#Preview {
    NativeBalanceGridCell(evm: .ETH, balance: 4)
    .preferredColorScheme(.dark)
    .environment(PriceModel.preview)
}
