//
//  NetworkDetailView.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit

struct NetworkDetailView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel

    let card: EthereumNetworkCard
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    
    @Namespace
    var animation
    
    var price: Double? {
        return priceModel.price(chain: card.chain, currency: currency)
    }
    var address: EthereumAddress { card.address }

    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    NetworkCardView(card: card, animation: animation)
                        .frame(height: 200)
                        .frame(maxWidth: 600)
                        .padding(.horizontal)
                    
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        GridRow {
                            WalletAction.GridButton(.receive, card: card)
                            WalletAction.GridButton(.send, card: card)
                        }
                        GridRow {
                            VStack {
                                BalanceGridCell(balance: card.value, price: price)
                                TokensGridCell(balances: card.tokens, transfers: [], address:address)
                            }
                            NftGridCell(nfts: card.nfts, address: address, favorite: nil, color: card.color)
                                .environment(card)
                        }
                        GridRow {
                            WalletAction.GridButton(.stake, card: card)
                            WalletAction.GridButton(.swap, card: card)
                        }
                        DateTransactions(address: card.address.string, transactions: card.transactions)
                    }
                    .environment(card)
                    .networkTheme(card: card)

                    .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal, .bottom], 16)
                    .frame(maxWidth: 1200)
                }
            }
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #else
        .background(.quaternary.opacity(0.5))
        #endif
        .background()
        .navigationTitle(card.name)
    }
}

enum NetworkCardDestination: String, CaseIterable {
    case send, receive, stake, swap, nft, tokens, balance
}
//
#Preview {
    NavigationStack {
        NetworkDetailView(card: .preview)
            .environmentPreview()
    }
}
