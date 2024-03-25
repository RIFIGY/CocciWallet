//
//  TransactionsListView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit


struct DateTransactions<T:TransactionProtocol>: View where T.Sorter == Date {

    @State var model: TransactionsModel
    let transactions: [T]
    
    var latestTransactions: [T] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return transactions.filter { $0.sorter >= oneMonthAgo }
    }
    
    
    var latest: [T] {
        latestTransactions.isEmpty ? Array(transactions.sorted{$0.sorter > $1.sorter}.prefix(10)) : latestTransactions
    }
    
    var thisYearsSorted: [Int] {
        thisYear.keys.sorted().reversed()
    }
    
    var previousYearsSorted: [Int] {
        previousYears.keys.sorted().reversed()
    }
    
    private let formatter = DateFormatter()
    
    @State private var selected: T?
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            if !latest.isEmpty {
                TransactionSection(header: "Latest") {
                    ForEach(latest) { tx in
//                        NavigationLink {
//                            TransactionDetailView(tx: tx)
//                                .environment(model)
//                                .navigationTitle(tx.title)
//                            #if os(iOS)
//                                .navigationBarTitleDisplayMode(.large)
//                            #endif
//                            #if !os(tvOS)
//                            .toolbarRole(.editor)
//                            #endif
//                        } label: {
                            VStack(spacing: 8) {
                                TransactionCellView(tx: tx, symbol: model.symbol)
                                if latest.last?.id != tx.id {
                                    Divider().frame(height: 1).foregroundStyle(.secondary)
                                }
                            }
                            .onTapGesture {
                                self.selected = tx
                            }
//                        }
                        .foregroundStyle(.primary)
                    }
                }
                .fullScreenCover(item: $selected) { tx in
                    NavigationStack {
                        TransactionDetailView(tx: tx)
                            .environment(model)
                            .navigationTitle(tx.title)
                        #if os(iOS)
                            .navigationBarTitleDisplayMode(.large)
                        #endif
                        #if !os(tvOS)
                        .toolbarRole(.editor)
                        #endif
                    }
                }
            }
            
            if !thisYearsSorted.isEmpty {
                MonthlySection<T>(months: thisYear)
            }
            
            if !previousYearsSorted.isEmpty {
                YearlySection<T>(previousYears: previousYears)
            }
        }
        .environment(model)
    }
    
    
    private let calendar = Calendar.current
    private var currentYear: Int {
        calendar.component(.year, from: Date())
    }
    
    var thisYear: [Int: [T]] {
        let thisYearTransactions = transactions.filter {
            calendar.component(.year, from: $0.sorter) == currentYear
        }

        return Dictionary(grouping: thisYearTransactions) { transaction -> Int in
            calendar.component(.month, from: transaction.sorter)
        }
    }
    
    var previousYears: [Int: [T]] {
        let previousTransactions = transactions.filter {
            calendar.component(.year, from: $0.sorter) < currentYear
        }
        return Dictionary(grouping: previousTransactions, by: { 
            calendar.component(.year, from: $0.sorter) }
        )
    }
    
    
}




//
//#Preview {
//    TransactionsGroup(
//        model: TransactionViewModel<CocciWallet.Transaction>(
//            transactions: CocciWallet.Transaction.generatedDummyData,
//            address: Wallet.rifigy.address,
//            price: (3898.23, "usd"),
//            symbol: "ETH"
//        )
//    )
//}

