//
//  TransactionDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct TransactionDetailView: View {
    let tx: any TransactionProtocol
    
    let address: String
    
    var with: String {
        isOutGoing ? tx.toAddressString : tx.fromAddressString
    }
    
    var isOutGoing: Bool {
        address == tx.fromAddressString.lowercased()
    }
    
    var history: [any TransactionProtocol] {
        []
//        let address = isOutGoing ? tx.toAddressString.lowercased() : address
//        return model.transactions.filter{ tx in
//            tx.fromAddressString.lowercased() == address || tx.toAddressString.lowercased() == address
//        }.filter{$0.id != tx.id}

    }
    
    var body: some View {
        List {
            Section{
                NavigationLink {
                    TransactionInfoView(tx: tx)
                } label: {
                    Cell(tx: tx, price: 0, address: address)
                }
            }
            if !history.isEmpty {
                Section {
//                    ForEach(history, id: \.) { tx in
//                        NavigationLink {
//                            TransactionInfoView(tx: tx)
//                                .environment(model)
//                        } label: {
//                            Cell(tx: tx, price: model.price?.0, address: address)
//                        }
//                    }
                } header: {
                    VStack(alignment: .leading){
                        Text("Transaction History")
                            .foregroundStyle(.primary)
                            .font(.title)
                            .bold()
                        Text(with)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    .font(.headline)

                }
                .textCase(nil)
            }
        }
        .navigationTitle(tx.title)
    }
    
    struct Cell: View {
        let title: String
        let subtitle: String
        
        let detail: String
        let subDetail: String
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(detail)
                    Text(subDetail)
                        .padding(4)
                        .background(Color.systemGray)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .cornerRadius(6)
                }
            }
        }
    }
}

extension TransactionDetailView.Cell {
    init(tx: any TransactionProtocol, price: Double?, address: String) {
        if let date = tx.timestamp {
            self.title = date.formatted(date: .numeric, time: .omitted)
        } else {
            self.title = "Transfer"
        }
        let title = address == tx.toAddressString ? "Transfer From" : "Transfer To"
        self.subtitle = tx.title == "Transfer" ? title : tx.title
        self.detail = tx.amount?.string(decimals: 4) ?? ""
        self.subDetail = {
            if let price, let amount = tx.amount {
                "$" + (price * amount).string(decimals: 2)
            } else {
                ""
            }
        }()
    }

}

#Preview {
    TransactionDetailView(tx: Transaction.generatedDummyData.first!, address: Wallet.rifigy.address)
}
