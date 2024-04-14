//
//  ERCTransactions.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import Web3Kit
import WalletData

struct ERCTransactions<T:ERCTransfer>: View {
    let transfers: [WalletData.Token]
    let transactions: [T]

    let address: Web3Kit.EthereumAddress
    let symbol: String?

    
    
    var sorted: [T] {
        transactions.sorted{ $0.log.blockNumber > $1.log.blockNumber}
    }

    
    var body: some View {
        Section("Transactions") {
            ForEach(sorted) { tx in
                NavigationLink {
                    TransactionDetailView(tx: tx, address: address.string)
//                        .navigationTitle(tx.title)
//                    #if os(iOS)
//                        .navigationBarTitleDisplayMode(.large)
//                    #endif
//                    #if !os(tvOS)
//                    .toolbarRole(.editor)
//                    #endif
                } label: {
                    if let erc20 = transfers.first(where: {$0.address.lowercased() == tx.contract.string.lowercased()}) as? ERC20 {
                        TransactionCellView(tx: tx, symbol: erc20.symbol, decimals: erc20.decimals ?? 18, isCell: false)
                    } else {
                        TransactionCellView(tx: tx, symbol: symbol, isCell: false)
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }
    
}


//#Preview {
//    ERCTransactions()
//}
