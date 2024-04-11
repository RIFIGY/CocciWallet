//
//  TransactionsListView.swift
//  CocciWallet
//
//  Created by Michael on 4/4/24.
//

import SwiftUI
import Web3Kit
import ChainKit

typealias TransactionProtocol = ChainKit.TransactionProtocol

struct TransactionsList<C:View>: View {
    let title: String
    let items: Any?
    
    @ViewBuilder
    var content: C
    
    var body: some View {
        Group {
            if items != nil {
                List {
                    content
                }
            } else {
                ContentUnavailableView("No \(title)s", systemImage: "circle")

            }
        }
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        #if !os(tvOS)
        .toolbarRole(.editor)
        #endif
    }
}

struct TransactionsListView<T:TransactionProtocol>: View {
    let title: String
    let transactions: [T]?
    let address: String
    let symbol: String?
    
    var body: some View {
        TransactionsList(title: title, items: transactions){
            ForEach(transactions ?? []) { tx in
                NavigationLink {
                    TransactionDetailView(tx: tx, address: address)
                } label: {
                    TransactionCellView(tx: tx, symbol: symbol, isCell: false)
                }
            }
        }
    }
}


extension TransactionsListView {
    
    init(month: String, transactions: [T], address: String, symbol: String?) {
        self.transactions = transactions
        self.title = month
        self.address = address
        self.symbol = symbol

    }
    
}

struct TransactionSection<C:View>: View {

    let header: String
    @ViewBuilder let content: C
    
    var body: some View {
        SwiftUI.Section {
            VStack {
                content
            }
            .cellBackground(padding: 14, cornerRadius: 16)
        } header: {
            Text(header)
                .font(.title2.weight(.bold))
                .padding(.top)
        }
        .textCase(nil)
    }
}

#Preview {
    TransactionsListView(title: "Title", transactions: Transaction.generatedDummyData, address: Wallet.rifigy.address.string, symbol: "ETH")
}
