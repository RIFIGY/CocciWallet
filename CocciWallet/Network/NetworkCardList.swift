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

struct NetworkCardList: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(WalletHolder.self) private var manager
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    @Environment(Navigation.self) private var navigation
    
    let networks: [EthereumNetworkCard]
    let settings: Wallet.Settings
    
    var update: (EthereumNetworkCard) async -> Void

    
    @State private var selectedToken: Balance<ERC20, ERC20Transfer>?
//    @Binding var showSettings: Bool
//    @Binding var showNewNetwork: Bool
//    @Binding var showWallets: Bool

    var body: some View {
        List{
            ForEach(networks.filter{!$0.isCustom}) { card in
                if settings.groupTokens {
                    CardSection(card: card)
                } else {
                    Section(card.name){
                        CardSection(card: card)
                    }
                }
            }
            
            ForEach(networks.filter{$0.isCustom}) { card in
                if settings.groupTokens {
                    CardSection(card: card)
                } else {
                    Section(card.name){
                        CardSection(card: card)
                    }
                }
            }
            
            if networks.isEmpty {
                Button("Add"){
                    self.navigation.showNewNetwork = true
                }
            }
        }

        .navigationDestination(item: $selectedToken) { token in
            ERC20DetailView(token.token, balance: token.balance, price: token.price, tx: token.transfers ?? [], network: token.network)
        }
        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Button(systemName: "wallet.pass"){
//                    showWallets = true
//                }
//                .foregroundStyle(.indigo)
//
//            }
//            ToolbarItem(placement: .cancellationAction) {
//                Button(systemName: "gearshape") {
//                    showSettings = true
//                }
//                .foregroundStyle(.indigo)
//
//            }
        }
    }
    
    @ViewBuilder
    func CardSection(card: EthereumNetworkCard) -> some View {
        Cell(card: card, group: settings.groupTokens)
            .onTapGesture {
                self.navigation.selectedNetwork = card
            }
            .task {
                await update(card)
            }
//        if let card = card as? EthereumNetworkCard, !wallet.settings.groupTokens {
//            ForEach(Array(card.tokens.balances.keys) ) { contract in
//                if let balance = card.tokens.balances[contract] {
//                    ERC20TokenCell(contract, balance: balance, chain: card.chain, network: card.color, useNetworkColor: true)
//                        .onTapGesture {
//                            self.selectedToken = Balance(
//                                token: contract,
//                                balance: balance,
//                                price: priceModel.price(chain: card.chain, contract: contract.contract.string, currency: currency),
//                                transfers: [],
//                                chain: card.chain,
//                                network: card.color
//                            )
//                        }
//                }
//            }
//        }
    }
    
    
}

fileprivate extension NetworkCardList {
    struct Cell: View {
        @Environment(PriceModel.self) private var priceModel
        @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"

        let card: EthereumNetworkCard
        let group: Bool
        var price: Double? {
            nil
//            priceModel.price(chain: card.chain, currency: currency)
        }
        
        var body: some View {
            HStack {
                IconView(symbol: card.symbol, size: 42)
                    .frame(height: 40)
                VStack(alignment: .leading){
                    Text(card.name)
                    Group {
                        if group {
//                            Text(card.tokenInfo.contractInteractions.count.description + " Tokens")
                        } else if !card.symbol.isEmpty {
                            Text(card.symbol)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }


                Spacer()
                VStack(alignment: .trailing) {
                    if let balance = card.balance {
                        Text(balance, format: .crypto(decimals: card.decimals, precision: 4))
                    }
                    if let price {
                        Text(price, format: .currency(code: currency))
                    } else {
                        Text("--")
                    }
                }
            }
        }
    }
}

struct NetworkDestination: View {
    let card: EthereumNetworkCard
    let price: Double?
    @Binding var selected: EthereumNetworkCard?

    var remove: ()->Void
    
    @Namespace private var animation
    
    @State private var showToolbar:(Bool,CGFloat) = (false, 0)

    
    var body: some View {
        DestinationView(card: card, cardHeight: 200, animation: animation, showToolbar: $showToolbar, fadeDetails: false) {
            //dismiss
        } cardView: { card in
            NetworkCardView(
                card: card,
                price: price,
                animation: animation
            )
        } cardDetails: { card in
            NetworkView(card: card){
                remove()
            }
        }

    }
}

fileprivate struct Balance<E:Contract, T:ERCTransfer>: Identifiable, Hashable {
    static func == (lhs: Balance, rhs: Balance) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String { token.contract.string }
    let token: E
    let balance: BigUInt
    let price: Double?
    let transfers: [T]?
    let chain: Int
    let network: Color
}

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