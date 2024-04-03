//
//  YearlySection.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct YearlySection<T:TransactionProtocol>: View where T.Sorter == Date {
    @Environment(TransactionsModel.self) private var model
    
    let previousYears: [Int: [T]]

    
    var previousYearsSorted: [Int] {
        previousYears.keys.sorted().reversed()
    }
    
    @State private var selected: Int?

    var showYears: Binding<Bool> { .init {
            selected != nil
        } set: { newValue in
            if !newValue { self.selected = nil }
        }
    }
    
    var body: some View {
        TransactionSection(header: "Previous Years") {
            VStack {
                ForEach(previousYearsSorted, id: \.self) { year in
//                    NavigationLink {
//                        YearDetailView(
//                            year: year,
//                            months: transactions(forYear: year)
//                        )
//                            .environment(model)
//                    } label: {
                        VStack {
                            DateCellView(
                                title: year.description,
                                count: previousYears[year]?.count ?? 0,
                                fromScroll: true
                            )
                            if previousYearsSorted.last != year {
                                Rectangle().frame(height: 1).foregroundStyle(.secondary)
                            }
                        }
                        .onTapGesture {
                            self.selected = year
                        }
//                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationDestination(isPresented: showYears) {
                if let selected {
                    NavigationStack {
                        YearDetailView(
                            year: selected,
                            months: transactions(forYear: selected)
                        )
                            .environment(model)
                    }
                }
            }
        }
    }
    
    func transactions(forYear year: Int) -> [Int: [T]] {
        let calendar = Calendar.current

        guard let yearTransactions = previousYears[year] else {return [:] }

        let transactionsByMonth = Dictionary(grouping: yearTransactions) { transaction -> Int in
            return calendar.component(.month, from: transaction.sorter)
        }

        return transactionsByMonth
    }
}

struct YearDetailView<T:TransactionProtocol>: View where T.Sorter == Date {
    @Environment(TransactionsModel.self) private var model

    let year: Int
    let months: [Int: [T]]
    let formatter = DateFormatter()

    var body: some View {
        List {
            ForEach(months.keys.sorted().reversed(), id: \.self) { month in
                let transactions = months[month] ?? []
                let month = formatter.name(month: month)
                NavigationLink {
                    MonthDetailView(month: month, transactions: transactions)
                        .environment(model)
                } label: {
                    DateCellView(title: month, count: transactions.count)
                }
            }
        }
        .navigationTitle(year.description)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        #if !os(tvOS)
        .toolbarRole(.editor)
        #endif
        
    }
}

//import Web3Kit
//#Preview {
//    YearlySection<CocciWallet.Transaction>()
//        .environment(TransactionViewModel<CocciWallet.Transaction>.preview )
//}
