//
//  ERCTransactions.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import Web3Kit

struct ERCTransactions<E:ERC, T:ERCTransfer>: View {
    
    @State var model: TransactionsModel

    let transfers: [ E : [T] ]

    var transactions: [T] {
        transfers.flatMap{$0.value}
    }
    
    var sorted: [T] {
        transactions.sorted{ $0.sorter > $1.sorter}
    }

    
    var body: some View {
        Section("Latest") {
            ForEach(sorted) { tx in
                NavigationLink {
                    TransactionDetailView(tx: tx)
                        .environment(model)
                        .navigationTitle(tx.title)
                    #if os(iOS)
                        .navigationBarTitleDisplayMode(.large)
                    #endif
                    #if !os(tvOS)
                    .toolbarRole(.editor)
                    #endif
                } label: {
                    VStack(spacing: 8) {
                        if let erc20 = transfers.keys.first(where: {$0.contract == tx.contract}) as? ERC20 {
                            TransactionCellView(tx: tx, decimals: erc20.decimals, symbol: erc20.symbol)
                        } else {
                            TransactionCellView(tx: tx, symbol: model.symbol)
                        }
                        if sorted.last?.id != tx.id {
                            Divider().frame(height: 1).foregroundStyle(.secondary)
                        }
                    }
                    .environment(model)
                }
                .foregroundStyle(.primary)
            }
        }
    }
    
}


//#Preview {
//    ERCTransactions()
//}
