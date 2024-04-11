//
//  ERC20CellView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI
import Web3Kit
import OffChainKit

struct TokenCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    @Environment(PriceModel.self) private var priceModel
    let contract: String
    let name: String?
    let symbol: String?
    let decimals: UInt8
    let balance: BigUInt?
    
    let network: Color
    var useNetworkColor: Bool = false
        
    let icon: Icon?
    
    var color: Color {
        if useNetworkColor {
            network
        } else {
            icon?.color ?? network
        }
    }
    
    
    var value: Double? {
        balance?.value(decimals: decimals)
    }
    
    var body: some View {
        HStack {
            IconImage(symbol: symbol, size: 42, override: color)
            VStack(alignment: .leading) {
                Text(name ?? "Name")
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(symbol ?? "Symbol")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Group {
                if let value {
                    VStack(alignment: .trailing) {
                        Text(value, format: .number.precision(.fractionLength(2)))
                        if let price = priceModel.price(contract: contract, currency: currency) {
                            Text(price * value, format: .currency(code: currency))
                                .foregroundStyle(.secondary)
                        } else {
                            Text("--")
                        }
                    }
                    .padding(.leading, 4)
                } else {
                    Text("0")
                }
            }
            .foregroundStyle(color)
        }
    }
}


import ChainKit
import BigInt
extension TokenCell {
    init<C:Contract>(_ contract: C, balance: BigUInt?, network: Color, useNetworkColor: Bool = false) {
        self.name = contract.name
        self.symbol = contract.symbol
        self.decimals = contract.decimals
        self.balance = balance
        self.contract = contract.contract.string
        self.useNetworkColor = useNetworkColor
        self.icon = Icon(symbol: contract.symbol)
        self.network = network
    }
}

#Preview {
    List {
        TokenCell(ERC20.USDC, balance: 353823, network: .ETH)
    }
    .environment(PriceModel() )
}
