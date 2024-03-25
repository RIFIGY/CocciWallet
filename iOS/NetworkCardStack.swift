//
//  WalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import SwiftUI
import CardSpacing
import Web3Kit


struct NetworkCardStack<Header:View, Footer:View>: View {
    @AppStorage("currency") var currency: String = "usd"
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel

    @Bindable var wallet: WalletModel
    
    let animation: Namespace.ID
    @Binding var showDetail: Bool

    let header: Header
    let footer: Footer
    
    var delete: (NetworkCard) -> Void
    
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
            NetworkCardView(card: card, price: price(card.evm), animation: animation)
                .task {
                    await update(card: card)
                }
        } cardDetail: { card in
            NetworkWalletView(card: card)
                .task {
                    await fetchPrice(for: card)
                }
        } cardIcon: { card in
            cardIcon(card)
        }
    }
    
    private func update(card: NetworkCard) async {
        let client = network.getClient(card.evm)
        let address = wallet.address
        
        await card.update(with: client, address: address)
    }
    
    private func fetchPrice(for card: NetworkCard) async {
        guard let platform = card.evm.coingecko else {return}
        let platformContracts = [ (platform, card.erc20Interactions ) ]
        
        await priceModel.fetchPrices(platformContracts: platformContracts)
    }

    
    private func price(_ evm: EVM) -> (Double, String)? {
        priceModel.price(evm: evm, currency: currency)
    }
    
    func cardIcon(_ card: NetworkCard?) -> some View {
        ZStack {
            Rectangle().fill(card?.color ?? .ETH)
            Text(card?.evm.symbol ?? "").fontWeight(.semibold)
                .font(.caption)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    NetworkCardStack(wallet: .init(.rifigy), animation: Namespace().wrappedValue, showDetail: .constant(false), header: EmptyView(), footer: EmptyView()) { _ in }
        .environment(NetworkManager())
        .environment(PriceModel.preview)
}
