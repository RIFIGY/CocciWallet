//
//  Widgets.swift
//  Widgets
//
//  Created by Michael Wilkowski on 3/29/24.
//

import WidgetKit
import SwiftUI
import OffChainKit

struct TokenWidgetView: View {
    var entry: TokenProvider.Entry
    
    var intent: TokenIntent {
        entry.intent
    }
    
    var contract: ContractEntity {
        entry.intent.contract
    }
    
    var balance: Double? {
        entry.balance
    }
    
    var price: Double? { entry.price }
    var currency: String { entry.intent.currency }
    
    var showBackground: Bool {
        icon?.color != nil && entry.intent.showBackground
    }
    
    var icon: Icon? {
        Icon(symbol: contract.symbol)
    }
    
    let iconSize: CGFloat = 52
    
    var body: some View {
        ZStack {
            if showBackground {
                icon?.color
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(contract.name)
                    .font(.title3.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if let symbol = contract.symbol {
                    Text(symbol)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    IconView(
                        symbol: contract.symbol ?? "generic",
                        size: iconSize, glyph: showBackground ? .white : nil
                    )
                    .offset(x: -(iconSize/8))
                    Spacer()
                }
                .padding(.vertical, 2)
                
                ValueLabel(
                    price: entry.price,
                    balance: entry.balance,
                    symbol: contract.symbol,
                    currency: entry.intent.currency,
                    showBalance: intent.showBalance,
                    showFiat: intent.showFiat
                )
                .font(.title2)
            }
            .padding()
            .foregroundStyle(showBackground ? .white : .primary)
        }
    }
    
    struct ValueLabel: View {
        let price: Double?
        let balance: Double?
        let symbol: String?
        let currency: String
        
        let showBalance: Bool
        let showFiat: Bool
        var error: String?
        
        var body: some View {
            if let balance {
                if showBalance, !showFiat {
                    HStack(spacing: 2) {
                        Text(balance, format: .number)
                        if let symbol = symbol {
                            Text(symbol)
                                .font(.caption2)
                        }
                        Spacer()
                    }
                } else if let price {
                    if showFiat {
                        Text(balance * price, format: .currency(code: currency))
                    } else {
                        Text(price, format: .currency(code: currency))
                    }
                }
            } else if let price {
                Text(price, format: .currency(code: currency))
            } else if let error {
                Text(error)
                    .font(.caption2)
            }
        }
    }
}

struct TokenWidgets: Widget {
    let kind = "Token Widgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: TokenIntent.self, provider: TokenProvider()) { entry in
            TokenWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled() // Here
    }
}

fileprivate extension TokenIntent {
    static var usdc: TokenIntent {
        let intent = TokenIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .usdc
        intent.currency = "usd"
        intent.showBalance = true
        intent.showFiat = false
        intent.showBackground = true
        return intent
    }
    
    static var usdcB: TokenIntent {
        let intent = TokenIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .usdc
        intent.currency = "usd"
        intent.showBalance = false
        intent.showFiat = false
        intent.showBackground = false
        return intent
    }
}

#Preview(as: .systemSmall) {
    TokenWidgets()
} timeline: {
    TokenEntry(date: .now, intent: .usdc, balance: 140, price: 1.0, error: nil)
    TokenEntry(date: .now, intent: .usdcB, balance: 89, price: 1.0, error: nil)
}
