//
//  ERC20DetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/6/24.
//

import SwiftUI
import BigInt
import Web3Kit

struct ERC20DetailView: View {

    let address: String
    let name: String?
    let symbol: String?
    let decimals: UInt8
    
    var balance: BigUInt?
    var price: Double?
    
    let transactions: [any ERCTransfer]

    
    var body: some View {
        VStack {
            IconView(symbol: symbol ?? "", size: 100)
            Text(name ?? address.shortened())
                .font(.largeTitle)
            Text(symbol ?? "--")
                .font(.title)
            Text(address)
                .font(.caption)
                .foregroundStyle(.secondary)
            .padding(.horizontal)
            if let balance {
                Text(balance.value(decimals: decimals).string(decimals: 8) ?? "--")
            }
            if !transactions.isEmpty {
//                TransactionList(transactions: transactions, decimals: decimals)
            }

        }
    }
    
//    struct IconView: View {
//        let icon: Icon?
//        var body: some View {
//            if let icon {
//                HStack {
//                    Image(icon.black)
//                    Image(icon.white)
//                    Image(icon.image)
//                    Image(icon.icon)
//                }
//                .padding()
//                .background(Color.secondary)
//                .padding()
////                .background( icon.hexColor ?? Color.orange)
//            }
//        }
//    }
}

extension ERC20DetailView {
    init(_ contract: any Web3Kit.ERC20Protocol, balance: BigUInt?, price: Double? = nil, tx: [any ERCTransfer] ) {
        self.address = contract.contract
        self.name = contract.name
        self.symbol = contract.symbol
        self.decimals = contract.decimals
        self.balance = balance
        self.price = price
        self.transactions = tx
        
    }
}

//fileprivate struct TransactionsListView<T:ETHTransaction>: View {
//    
//    let transactions: [T]
//    
//    var body: some View {
//        List {
//            ForEach(transactions, id: \.toAddress) {
//                TransactionCell(transaction: $0)
//            }
//        }
//    }
//}
//
//#Preview {
//    ERC20DetailView(
//        contract: ERC20Contract.USDC,
//        transactions: [
//            .init(toAddress: Wallet.rifigy.address, fromAddress: Wallet.wallet.address, bigValue: 2000000),
//            .init(toAddress: Wallet.wallet.address, fromAddress: Wallet.rifigy.address, bigValue: 4000000)
//        ],
//        balance: 20000000,
//        price: 1.00
//    )
//}
