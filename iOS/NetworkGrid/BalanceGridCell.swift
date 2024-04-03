//
//  BalanceGridCell.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI
import Web3Kit

struct BalanceGridCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"

    let balance: Double?
    var price: Double?
    
    var value: Double? {
        guard let balance, let price else {return nil}
        return balance * price
    }
    
    @State private var showBalance = false
    
    var body: some View {
        GridCell(title: "Balance", balance: balance, value: value)
            .onTapGesture {
                showBalance = true
            }
            .navigationDestination(isPresented: $showBalance) {
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
    BalanceGridCell(balance: 4, price: 300)
    .preferredColorScheme(.dark)
}
