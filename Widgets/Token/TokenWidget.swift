//
//  Widgets.swift
//  Widgets
//
//  Created by Michael Wilkowski on 3/29/24.
//

import WidgetKit
import SwiftUI
import OffChainKit
import Web3Kit
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

extension WalletEntity {
    static let rifigy = WalletEntity(name: "Rifigy", address: Wallet.rifigy.address.string)
    static let wallet = WalletEntity(name: Wallet.wallet.name, address: Wallet.wallet.address.string)
    static let dave = WalletEntity(name: Wallet.dave.name, address: Wallet.dave.address.string)
    static let ganache = WalletEntity(name: Wallet.ganache.name, address: Wallet.ganache.address.string)

}

extension NetworkEntity {
    static let ETH = NetworkEntity(id: EthereumCardEntity.ETH.chain.description, title: EthereumCardEntity.ETH.name, symbol: EthereumCardEntity.ETH.symbol)
}

import WalletData
extension ContractEntity {
    static let munko = ContractEntity(address: ERC721.Munko.contract.string, name: ERC721.Munko.name, symbol: ERC721.Munko.symbol, decimals: nil)
    static let usdc = ContractEntity(address: ERC20.USDC.contract.string, name: ERC20.USDC.name, symbol: ERC20.USDC.symbol, decimals: ERC20.USDC.decimals)

}

extension NFTIntent {
    
    static var m2309: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = []
        return intent
    }
    
    static var m2310: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2310
        intent.showBackground = true

        intent.randomNFT = false
        intent.nfts = []
        
        return intent
    }
    
    static var m2309_4: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = [.munko2309, .munko2310, .munko2309, .munko2310]
        return intent
    }
    
    static var m2309_2: NFTIntent {
        let intent = NFTIntent()
        intent.wallet = .rifigy
        intent.network = .ETH
        intent.contract = .munko
        intent.nft = .munko2309
        intent.randomNFT = false
        intent.nfts = [.munko2309, .munko2310]
        return intent
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
