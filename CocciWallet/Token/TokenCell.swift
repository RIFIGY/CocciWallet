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
    @Environment(\.networkTheme) private var theme

    let contract: String
    let name: String?
    let symbol: String?
    let decimals: UInt8
    let balance: Double?
    
    var network: Color { theme.color }
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
        balance
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


extension TokenCell {
    init(_ token: Token, useNetworkColor: Bool = false) {
        self.name = token.name
        self.symbol = token.symbol
        self.decimals = token.decimals ?? 18
        self.balance = token.balance
        self.contract = token.address
        self.useNetworkColor = useNetworkColor
        self.icon = Icon(symbol: token.symbol)
    }
}

#Preview {
    let preview = Preview()
    return List {
        TokenCell(.USDC)
    }
    .environmentPreview()
}

