//
//  TransactionView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct TransactionCellView: View {
    @Environment(TransactionsModel.self) private var model
    
    let title: String
    let from: String
    let to: String
    let date: Date?
    let amount: Double?
    
    let symbol: String?
    
    var evmColor: Color { model.evm.color }
    
    var isCell = true
    
    
    var address: String { model.address }
//    let decimals: UInt8
    
    var isOutgoing: Bool {
        to.lowercased() != address.lowercased()
    }
    
    var titleText: String {
        let string = "Transfer"
        guard self.title == string else {return title}
        return isOutgoing ? string+" To" : string+" From"
    }

    
//
    var body: some View {
        HStack(alignment: .center) {
            TransactionIcon(symbol: symbol, evm: model.evm)
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 2) {
                    Text(titleText)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
    //                        .fontWeight(.semibold)
                    Group {
                        Group {
                            if isOutgoing {
                                Text(to.shortened(10))
                            } else if !from.isEmpty {
                                Text(from.shortened(10))
                            }
                        }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        if let date = date {
                            Text(date.formatted(date: .numeric, time: .omitted))
                        }
                    }
                    .foregroundStyle(.secondary)
                    .font(.callout)
                }
                Spacer()
                HStack(alignment: .top){
                    VStack(alignment: .trailing, spacing: 2) {
                        if let amount, amount != 0 {
                            Text(amount, format: .number)
                            if let price = model.price {
                                Text(amount * price.0, format: .currency(code: price.1))
                                    .padding(4)
                                    .background(Color.systemGray)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .cornerRadius(6)
                            }
                        }
                    }
                    if isCell {
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

extension TransactionCellView {
    init<T:TransactionProtocol>(tx: T, isCell: Bool = true, decimals: UInt8 = 18, symbol: String?){
        if let amount = tx.amount {
            self.amount = amount
        } else if let value = tx.bigValue {
            self.amount = value.value(decimals: decimals)
        } else {
            self.amount = nil
        }
        self.isCell = isCell
        self.title = tx.title
        self.from = tx.fromAddressString
        self.to = tx.toAddressString
        self.date = tx.date
        self.symbol = symbol
    }
}

//
//#Preview {
//    TransactionCellView(tx: CocciWallet.Transaction.generatedDummyData.first!, isCell: true)
//
//}
//
//#Preview {
//    DateCellView(title: "Title", count: 0)
//}
//
//
//#Preview {
//    TransactionCellView(tx: Transaction(
//        title: "Apple Store",
//        subtitle: "New York, NY",
//        amount: 44.54,
//        date: .init(timeIntervalSinceNow: -60 * 60 * 60 * 100)
//    ))
//}
