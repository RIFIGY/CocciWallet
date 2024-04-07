//
//  ERC20DetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/6/24.
//

import SwiftUI
import BigInt
import Web3Kit
import OffChainKit

struct ERC20DetailView<E:ERC20Protocol, T:ERCTransfer>: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"

    let contract: E
    let address: String
    let name: String?
    let symbol: String?
    let decimals: UInt8
    
    var balance: BigUInt?
    var price: Double?
    
    let transactions: [T]
    
    let chain: Int
    let network: Color
    
    var icon: Icon? {
        Icon(symbol: symbol)
    }
    
    var color: Color {
        icon?.color ?? network
    }
    
    
    var value: Double? {
        guard let price, let value = balance?.value(decimals: decimals) else {return nil}
        return value * price
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                IconImage(symbol: symbol, size: 164, fallback: network)

                Text(name ?? address.shortened())
                    .font(.largeTitle.weight(.semibold))
                Text(symbol ?? "--")
                    .font(.title)
                    .foregroundStyle(.secondary)
                VStack(alignment: .trailing) {
                    Text(address)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(.secondary)
                    Button(systemName: "circle") {
                        
                    }
                    .foregroundStyle(color)
                    .padding([.trailing, .bottom])
                }

                Grid {
                    GridRow {
                        if let balance {
                            GridCell(title: "Balance", balance: balance.value(decimals: decimals), value: value)
                        }
                        if let price {
                            GridCell(title: "Price", detail: "1 \(symbol ?? "Token")", value: price.formatted(.currency(code: currency)))
                        }
                    }
                    GridRow {
                        GridCell.Button(.send, color: color) {
                            
                        }
                        GridCell.Button(.receive, color: color) {
                            
                        }
                    }
                    GridRow {
                        GridCell.Button(.stake, color: color) {
                            
                        }
                        GridCell.Button(.swap, color: color) {
                            
                        }
                    }
                }
                .networkTheme(chain: chain, symbol: self.symbol, color: color, decimals: decimals)

                if !transactions.isEmpty {
                    ERCTransactions(transfers: [contract], transactions: transactions, address: address, symbol: symbol)
//                    TransactionList(transactions: transactions, decimals: decimals)
                }
            }
            .padding(.horizontal)
        }
        .background(Color.systemGray)
        .navigationBarBackButton(name, color: color)
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
    init(_ contract: E, balance: BigUInt?, price: Double? = nil, tx: [T], network: Color, chain: Int ) {
        self.contract = contract
        self.address = contract.contract
        self.name = contract.name
        self.symbol = contract.symbol
        self.decimals = contract.decimals
        self.balance = balance
        self.price = price
        self.transactions = tx
        self.chain = chain
        self.network = network
        
    }
}

#Preview {
    ERC20DetailView(
        ERC20.USDC,
        balance: 20000000,
        price: 1.00,
        tx: [ERC20Transfer](),
        network: .ETH,
        chain: 1
    )
}
