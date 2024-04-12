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


struct NetworkCardStack: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    @Environment(Navigation.self) private var navigation

    
    @Bindable var wallet: Wallet
    
    var name: String { wallet.name }
//    @Binding var networks: [EthereumNetworkCard]
    
    @Namespace var animation

    
    
    @State private var showDetail = false
    @State private var selected: EthereumNetworkCard?
    @State private var showNewNetwork = false
    
    var body: some View {
        CardListView(
            cards: wallet.networks,
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
                    wallet.networks.remove(card)
                    selected = nil
                }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
//            .environment(wallet)
//            .navigationBarBackButton(wallet.name, color: card.color)
        } cardIcon: { card in
            CardIcon(color: card?.color, symbol: card?.symbol)
        }
        .sheet(isPresented: $showNewNetwork) {
            AddNetworkView(address: wallet.address) { network in
                guard !wallet.networks.map({$0.chain}).contains(network.chain) else {return}
                wallet.networks.append(network)
                showNewNetwork = false
            }
        }
    }
    

    private func update(_ card: EthereumNetworkCard) async {
        guard let client = network.getClient(chain: card.chain) else {return}
        let updated: Bool = await card.update(with: client.node)
        await card.fetchTransactions()

        if updated {
            await fetchPrice(for: card)
        }
    }

    private func fetchPrice(for card: EthereumNetworkCard) async {
        guard let platform = CoinGecko.AssetPlatform.PlatformID(chainID: card.chain) else {return}
        let contracts = card.tokens.map{$0.key.contract.string}
        await priceModel.fetchPrices(contracts: contracts, platform: platform, currency: currency)
    }
    
    var footer: some View {
        Button("Add"){
            showNewNetwork = true
        }
        .buttonStyle(.bordered)
        .padding(.vertical, 32)
    }

    var header: some View {
        HStack {
            Text(name)
                .font(.largeTitle.weight(.bold))
            Spacer()
            HStack {
                HeaderButton(systemName: "wallet.pass") {
                    withAnimation {
                        navigation.showWallets = true
                    }
                }
                HeaderButton(systemName: "gearshape") {
                    navigation.showSettings = true
                }
            }
        }
        .padding(.horizontal)
    }


}

fileprivate struct HeaderButton: View {
    @Environment(\.colorScheme) var colorScheme

    let systemName: String
    let action: () -> Void
    
    var background: Color {
        colorScheme == .light ? .black : .white
    }
    
    var foreground: Color {
        colorScheme == .light ? .white : .black
    }
    
    var body: some View {
        SwiftUI.Button {
            action()
        } label: {
            Image(systemName: systemName)
                .foregroundStyle(foreground)
                .padding(10)
                .background(background)
                .clipShape(.circle)
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
