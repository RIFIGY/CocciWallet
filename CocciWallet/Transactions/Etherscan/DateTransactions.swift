//
//  TransactionsListView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit
import OffChainKit
import ChainKit

extension Etherscan.Transaction: TransactionProtocol {
    public var sorter: Date {
        date
    }
    
    public var to: Web3Kit.EthereumAddress {
        .init(toAddress)
    }
    
    public var from: Web3Kit.EthereumAddress {
        .init(fromAddress ?? "")
    }
    
    public typealias Sorter = Date
    
    public typealias Address = Web3Kit.EthereumAddress
    
    public var subtitle: String {
        date.formatted(date: .numeric, time: .omitted)
    }
    
    public var bigValue: BigUInt? {
        nil
    }
    
    public var timestamp: Date? {
        self.date
    }
    
    public var id: Date {
        self.date
    }
    
    
}

struct DateTransactions<T:TransactionProtocol>: View {
    let address: String
    let transactions: [T]
    var symbol: String?
    
    
    var latestTransactions: [T] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return transactions.filter { $0.timestamp ?? .now >= oneMonthAgo }
    }
    
    
    var latest: [T] {
        latestTransactions.isEmpty ? Array(transactions.sorted{($0.timestamp ?? .now) > ($1.timestamp ?? .now)}.prefix(10)) : latestTransactions
    }
    
    var thisYearsSorted: [Int] {
        thisYear.keys.sorted().reversed()
    }
    
    var previousYearsSorted: [Int] {
        previousYears.keys.sorted().reversed()
    }
    
    private let formatter = DateFormatter()
    
    @State private var selected: T?
    
    @State private var selectedYear: Int?

    var showYears: Binding<Bool> { .init {
            selectedYear != nil
        } set: { newValue in
            if !newValue { self.selectedYear = nil }
        }
    }
    
    
    @State private var selectedMonth: Int?

    var showMonths: Binding<Bool> { .init {
        selectedMonth != nil
    } set: { newValue in
        if !newValue { self.selectedMonth = nil }
    }
 }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            if !latest.isEmpty {
                TransactionSection(header: "Latest") {
                    ForEach(latest) { tx in
                            VStack(spacing: 8) {
                                TransactionCellView(tx: tx, symbol: symbol)
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

            }
            
            if !thisYearsSorted.isEmpty {
                MonthlySection<T>(months: thisYear, selected: $selectedMonth)
            }
            
            if !previousYearsSorted.isEmpty {
                YearlySection<T>(previousYears: previousYears, selected: $selectedYear)
            }
        }
        .navigationDestination(item: $selected) { tx in
            TransactionDetailView(tx: tx, address: address)
                .navigationTitle(tx.title)
                #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
                #endif
                #if !os(tvOS)
                .toolbarRole(.editor)
                #endif
        }
        .navigationDestination(isPresented: showYears) {
            if let year = selectedYear {
                let months = transactions(forYear: year)
                TransactionsList(title: year.description, items: months) {
                    ForEach(months.keys.sorted().reversed(), id: \.self) { month in
                        let transactions = months[month] ?? []
                        let month = formatter.name(month: month)
                        NavigationLink {
                            TransactionsListView(month: month, transactions: transactions, address: address, symbol: symbol)
                        } label: {
                            TransactionCellView(title: month, count: transactions.count)
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: showMonths) {
            if let month = selectedMonth {
                let transactions = thisYear[month] ?? []
                let monthString = formatter.name(month: month)
                TransactionsListView(month: monthString, transactions: transactions, address: address, symbol: symbol)
            }
        }
    }
    
    
    func transactions(forYear year: Int) -> [Int: [T]] {
        let calendar = Calendar.current

        guard let yearTransactions = previousYears[year] else {return [:] }

        let transactionsByMonth = Dictionary(grouping: yearTransactions) { transaction -> Int in
            return calendar.component(.month, from: transaction.timestamp ?? .now)
        }

        return transactionsByMonth
    }
    
    private let calendar = Calendar.current
    private var currentYear: Int {
        calendar.component(.year, from: Date())
    }
    
    var thisYear: [Int: [T]] {
        let thisYearTransactions = transactions.filter {
            calendar.component(.year, from: $0.timestamp ?? .now) == currentYear
        }

        return Dictionary(grouping: thisYearTransactions) { transaction -> Int in
            calendar.component(.month, from: transaction.timestamp ?? .now)
        }
    }
    
    var previousYears: [Int: [T]] {
        let previousTransactions = transactions.filter {
            calendar.component(.year, from: $0.timestamp ?? .now) < currentYear
        }
        return Dictionary(grouping: previousTransactions, by: { 
            calendar.component(.year, from: $0.timestamp ?? .now) }
        )
    }
    
    
}

import OffChainKit
import BigInt

//extension Etherscan.Transaction: TransactionProtocol {
//    public static func == (lhs: Etherscan.Transaction, rhs: Etherscan.Transaction) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    public var timestamp: Date? {
//        date
//    }
//    
//
//    public var sorter: Date {
//        self.date
//    }
//    
//    public var subtitle: String {
//        date.formatted(date: .numeric, time: .omitted)
//    }
//    
//    public var bigValue: BigUInt? {
//        guard let value else {return nil}
//        return BigUInt(value)
//    }
//    
//    public var toAddressString: String {
//        self.to
//    }
//    
//    public var fromAddressString: String {
//        self.from ?? ""
//    }
//    
//    public var id: Date { self.date }
//    
//    
//}


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

