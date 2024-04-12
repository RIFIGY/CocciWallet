//
//  NetworkCardList.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/2/24.
//

import SwiftUI
import OffChainKit
import CardSpacing
import Web3Kit
import BigInt
import ChainKit

struct NetworkList: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    @Environment(Navigation.self) private var navigation
    
    
    @Bindable var wallet: Wallet
    @Binding var selectedCard: EthereumNetworkCard?
    
    var networks: [EthereumNetworkCard] {
        wallet.networks
    }

    var settings: Wallet.Settings {
        wallet.settings
    }
        
    var cards: [EthereumNetworkCard]{
        networks
    }
    
    var custom: [EthereumNetworkCard] {
        []
    }
    
    var body: some View {
        List{
            ForEach(cards) { card in
                NetworkCell(network: card)
                    .task {
                        await update(card)
                    }
                    .onTapGesture {
                        withAnimation {
                            self.selectedCard = card
                        }
                    }
            }
            Button("Add"){
                self.navigation.showNewNetwork = true
            }
            .frame(maxWidth: .infinity)
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
    
}

struct NetworkCell: View {
    let network: EthereumNetworkCard
    
    var compact: Bool = false
    var size: CGFloat = 42
        
    var body: some View {
        if compact {
            cell
        } else {
            banner
        }
    }
    
    var banner: some View {
        HStack {
            IconView(symbol: network.symbol, size: size)
                .frame(height: 40)
            VStack(alignment: .leading){
                Text(network.name)
                Text(network.symbol)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                if let balance = network.balance {
                    Text(balance, format:.crypto(
                        decimals: network.decimals,
                        precision: 4
                    ))
                }
            }
        }
    }
    
    var cell: some View {
        IconCell(symbol: network.symbol, color: network.color) {
            Text(network.name)
        }
    }
}

//#Preview {
//    NetworkList(networks: [.preview], selected: .constant(nil), settings: .init())
//        .environmentPreview()
//}


//
//struct NetworkDestination: View {
//    let card: EthereumNetworkCard
//    let price: Double?
//    @Binding var selected: EthereumNetworkCard?
//
//    var remove: ()->Void
//    
//    @Namespace private var animation
//    
//    @State private var showToolbar:(Bool,CGFloat) = (false, 0)
//
//    
//    var body: some View {
//        DestinationView(card: card, cardHeight: 200, animation: animation, showToolbar: $showToolbar, fadeDetails: false) {
//            //dismiss
//        } cardView: { card in
//            NetworkCardView(
//                card: card,
//                price: price,
//                animation: animation
//            )
//        } cardDetails: { card in
//            NetworkView(card: card){
//                remove()
//            }
//        }
//
//    }
//}

//fileprivate struct Balance<E:Contract, T:ERCTransfer>: Identifiable, Hashable {
//    static func == (lhs: Balance, rhs: Balance) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    var id: String { token.contract.string }
//    let token: E
//    let balance: BigUInt
//    let price: Double?
//    let transfers: [T]?
//    let chain: Int
//    let network: Color
//}

//#Preview {
//    NetworkCardList(
//        networks: [EthereumNetworkCard.preview],
//        settings: .init(),
//        showSettings: .constant(false),
//        showNewNetwork: .constant(false),
//        showWallets: .constant(false)
//    )
//        .environmentPreview()
//}
//
//
