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

    @Binding var networks: [EthereumNetworkCard]
    
    let animation: Namespace.ID

    let header: Header
    let footer: Footer
    
    var update: (EthereumNetworkCard) async -> Void
    
    
    @State private var showDetail = false
    @State private var selected: EthereumNetworkCard?

    var body: some View {
        CardListView(
            cards: networks,
            additional: [],
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
                    await update(card)
                }
        } cardDetail: { card in
            NetworkView(card: card){
                withAnimation{
                    networks.remove(card)
                    selected = nil
                }
            }
//            .environment(wallet)
//            .navigationBarBackButton(wallet.name, color: card.color)
        } cardIcon: { card in
            CardIcon(color: card?.color, symbol: card?.symbol)
        }
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
//
//#Preview {
//    NetworkCardStack(wallet: .rifigy, animation: Namespace().wrappedValue, header: EmptyView(), footer: EmptyView()) { _ in }
//        .environment(NetworkManager())
//        .environment(PriceModel.preview)
//}
