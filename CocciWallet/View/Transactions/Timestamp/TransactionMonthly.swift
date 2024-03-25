//
//  MonthlySection.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct MonthlySection<T:TransactionProtocol>: View where T.Sorter == Date {
    @Environment(TransactionsModel.self) private var model

    var title: String = "This Year"
    
    var months: [Int: [T] ]

    var monthsSorted: [Int] {
        months.keys.sorted().reversed()
    }
    
    private let formatter = DateFormatter()
    
    @State private var selected: Int?

    var showMonths: Binding<Bool> { .init {
        selected != nil
    } set: { newValue in
        if !newValue { self.selected = nil }
    }
 }
    
    var body: some View {
        TransactionSection(header: title) {
            ForEach(monthsSorted, id: \.self) { month in
                let transactions = months[month] ?? []
                let monthString = formatter.name(month: month)
                
//                NavigationLink {
//                    MonthDetailView(month: monthString, transactions: transactions)
//                        .environment(model)
//                } label: {
                    VStack {
                        DateCellView(title: monthString, count: transactions.count, fromScroll: true)
                        if monthsSorted.last != month {
                            Divider().foregroundStyle(.secondary)
                                .padding(.vertical, 4)
                        }
                    }
                    .onTapGesture {
                        self.selected = month
                    }
//                }
                .foregroundStyle(.primary)
                
            }
        }
        .sheet(isPresented: showMonths) {
            if let selected {
                let transactions = months[selected] ?? []
                let monthString = formatter.name(month: selected)
                MonthDetailView(month: monthString, transactions: transactions)
                    .environment(model)
            }
        }
    }
}


struct MonthDetailView<T:TransactionProtocol>: View where T.Sorter == Date {
    @Environment(TransactionsModel.self) private var model

    let month: String
    let transactions: [T]?
    
    var body: some View {
        Group {
            if let transactions {
                List{
                    ForEach(transactions) { tx in
                        NavigationLink {
                            TransactionDetailView(tx: tx)
                                .environment(model)
                        } label: {
                            TransactionCellView(tx: tx, isCell: false, symbol: model.symbol)
                        }
                    }
                }
            } else {
                ContentUnavailableView("No Transactions", systemImage: "circle")
            }
        }
        .navigationTitle(month)
    #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
    #endif
        #if !os(tvOS)
        .toolbarRole(.editor)
        #endif
    }
}

extension DateFormatter {
    func name(month monthInt: Int) -> String {
        let monthIndex = monthInt - 1 // Adjust because arrays are zero-indexed
        if monthIndex >= 0 && monthIndex < self.monthSymbols.count {
            return self.monthSymbols[monthIndex]
        } else {
            return "Invalid month"
        }
    }
}

//#Preview {
//    MonthlySection<CocciWallet.Transaction>()
//        .environment(TransactionViewModel<CocciWallet.Transaction>.preview)
//}
