//
//  Transaction.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit
import BigInt
import OffChainKit
import ChainKit
//extension TransactionsModel {
//    static var preview: TransactionsModel {
//        .init(address: Wallet.rifigy.address, price: (100,"usd"))
//    }
//}

extension Transaction {
    static var preview: Transaction {
        .init(title: "Simple Transaction", subtitle: "My transaction preview", amount: 4_000_000_000_000_000_469, date: .now, toAddressString: Wallet.rifigy.address.string, fromAddressString: Wallet.wallet.address.string)
    }
}

struct Transaction: TransactionProtocol {
    var to: Web3Kit.EthereumAddress { .init(toAddressString) }
    
    var from: Web3Kit.EthereumAddress { .init(fromAddressString) }
    
    typealias Sorter = Date
        
    var sorter: Date { date }
    var id: String = UUID().uuidString
    let title: String
    let subtitle: String
    let amount: Double
    let date: Date
    var timestamp: Date? { date }
    var toAddressString: String = ""
    var fromAddressString: String = ""
    var bigValue: BigUInt? { BigUInt(integerLiteral: UInt64(amount)) }

    static var generatedDummyData: [Transaction] {
        var transactions: [Transaction] = []
        let calendar = Calendar.current
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        // Generate transactions for the last 24 months
        for monthOffset in 0..<24 {
            guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: today) else { continue }
            let year = calendar.component(.year, from: monthDate)
            let month = calendar.component(.month, from: monthDate)
            
            // Generate a random number of transactions for each month (between 1 and 5)
            let transactionsCount = Int.random(in: 1...5)
            for t in 0..<transactionsCount {
                let day = Int.random(in: 1...28) // Simplified to avoid dealing with month's last day
                let dateStr = "\(year)/\(String(format: "%02d", month))/\(String(format: "%02d", day))"
                guard let date = formatter.date(from: dateStr) else { continue }
                
                let amount = Double.random(in: -500...500)
                let transaction = Transaction(
                    title: "Transaction \(month)/\(day)",
                    subtitle: "Description for \(month)/\(day)",
                    amount: amount,
                    date: date,
                    toAddressString: t % 2 == 0 ? Wallet.wallet.address.string : Wallet.rifigy.address.string,
                    fromAddressString: t % 2 == 0 ? Wallet.rifigy.address.string : Wallet.wallet.address.string
                )
                transactions.append(transaction)
            }
        }
        
        return transactions
    }
}

//extension Etherscan.Transaction {
//    static var preview: Etherscan.Transaction {
//        
//    }
//}
//
//fileprivate extension Etherscan.Transaction {
//    
//}
