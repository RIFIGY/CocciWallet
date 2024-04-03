//
//  WalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import CardSpacing
import Web3Kit
import OffChainKit


struct NetworkCardStack<Header:View, Footer:View>: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel

    @Bindable var wallet: Wallet
    
    let animation: Namespace.ID

    let header: Header
    let footer: Footer
    
    var delete: (NetworkCard) -> Void
    
    @State private var showDetail = false
    @State private var selected: NetworkCard?

    var body: some View {
        CardListView(
            cards: wallet.cards,
            additional: wallet.custom,
            showDetail: $showDetail,
            animation: animation,
            header: header,
            footer: footer
        ) { card in
            NetworkCardView(
                card: card,
                price: priceModel.price(chain: card.chain, currency: currency),
                animation: animation
            )
                .task {
                    await update(card: card)
                }
        } cardDetail: { card in
            NetworkWalletView(card: card) {
                wallet.save()
            } remove: {
                withAnimation{
                    wallet.remove(card)
                    selected = nil
                }
            }
            .environment(wallet)
            .navigationBarBackButton(wallet.name, color: card.color)
        } cardIcon: { card in
            CardIcon(color: card?.color, symbol: card?.symbol)
        }
    }
    
    private func update(card: NetworkCard) async {
        let client = network.getClient(card)
        let updated = await card.update(with: client)
        if updated {
            wallet.save()
            await fetchPrice(for: card)
        }
    }
    
    private func fetchPrice(for card: NetworkCard) async {
        guard let platform = CoinGecko.AssetPlatform.PlatformID(chainID: card.chain) else {return}
        let contracts = card.tokenInfo.contractInteractions
        
        await priceModel.fetchPrices(contracts: contracts, platform: platform, currency: currency)
    }

}

struct CardIcon: View {
    let color: Color?
    let symbol: String?
    
    var body: some View {
        ZStack {
            Rectangle().fill(color ?? .ETH)
            Text(symbol ?? "").fontWeight(.semibold)
                .font(.caption)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    NetworkCardStack(wallet: .rifigy, animation: Namespace().wrappedValue, header: EmptyView(), footer: EmptyView()) { _ in }
        .environment(NetworkManager())
        .environment(PriceModel.preview)
}
