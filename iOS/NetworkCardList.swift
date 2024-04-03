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

struct NetworkCardList: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(WalletHolder.self) private var manager
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var wallet: Wallet

    @State private var selected: NetworkCard?
    @State private var selectedToken: Balance?
    @Binding var showSettings: Bool
    @Binding var showNewNetwork: Bool
    @Binding var showWallets: Bool

    
    @ViewBuilder
    func CardSection(card: NetworkCard) -> some View {
        Cell(card: card, group: wallet.settings.groupTokens)
            .onTapGesture {
                self.selected = card
            }
            .task {
                await update(card: card)
            }
        if !wallet.settings.groupTokens {
            ForEach(Array(card.tokenInfo.balances.keys) ) { contract in
                if let balance = card.tokenInfo.balances[contract] {
                    ERC20TokenCell(contract, balance: balance, chain: card.chain, network: card.color, useNetworkColor: true)
                        .onTapGesture {
                            self.selectedToken = Balance(
                                token: contract,
                                balance: balance,
                                price: priceModel.price(chain: card.chain, contract: contract.contract, currency: currency),
                                transfers: card.tokenInfo.transfers[contract],
                                chain: card.chain,
                                network: card.color
                            )
                        }
                }
            }
        }
    }
    
    var body: some View {
        List{
            ForEach(wallet.cards) { card in
                if wallet.settings.groupTokens {
                    CardSection(card: card)
                } else {
                    Section(card.title){
                        CardSection(card: card)
                    }
                }
            }
            
            ForEach(wallet.custom) { card in
                if wallet.settings.groupTokens {
                    CardSection(card: card)
                } else {
                    Section(card.title){
                        CardSection(card: card)
                    }
                }
            }
            
            Section {
                Button("Add"){
                    showNewNetwork = true
                }
                .buttonStyle(.bordered)
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity)
            }
                

        }
        .navigationDestination(item: $selected) { card in
            Destination(wallet: wallet, card: card, price: 0, selected: $selected){
                withAnimation {
                    wallet.remove(card)
                    self.selected = nil
                }
            }
            .environment(wallet)
        }
        .navigationDestination(item: $selectedToken) { token in
            ERC20DetailView(token.token, balance: token.balance, price: token.price, tx: token.transfers ?? [], network: token.network, chain: token.chain)
        }
        .navigationTitle(wallet.name)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(systemName: "wallet.pass"){
                    showWallets = true
                }
                .foregroundStyle(.indigo)

            }
            ToolbarItem(placement: .cancellationAction) {
                Button(systemName: "gearshape") {
                    showSettings = true
                }
                .foregroundStyle(.indigo)

            }
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

fileprivate extension NetworkCardList {
    struct Cell: View {
        @Environment(PriceModel.self) private var priceModel
        @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"

        let card: NetworkCard
        let group: Bool
        var price: Double? {
            priceModel.price(chain: card.chain, currency: currency)
        }
        
        var body: some View {
            HStack {
                IconView(symbol: card.symbol, size: 42)
                    .frame(height: 40)
                VStack(alignment: .leading){
                    Text(card.title)
                    Group {
                        if group {
                            Text(card.tokenInfo.contractInteractions.count.description + " Tokens")

                        } else if let symbol = card.symbol {
                            Text(symbol)
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

fileprivate struct Destination: View {
    let wallet: Wallet
    let card: NetworkCard
    let price: Double?
    @Binding var selected: NetworkCard?

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
            NetworkWalletView(card: card) {
                wallet.save()
            } remove: {
                remove()
            }
            .navigationBarBackButton(wallet.name, color: card.color)
        }

    }
}

fileprivate struct Balance: Identifiable, Hashable {
    static func == (lhs: Balance, rhs: Balance) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String { token.contract }
    let token: any ERC20Protocol
    let balance: BigUInt
    let price: Double?
    let transfers: [any ERCTransfer]?
    let chain: Int
    let network: Color
}

#Preview {
    NetworkCardList(wallet: .rifigy, showSettings: .constant(false), showNewNetwork: .constant(false), showWallets: .constant(false))
        .environmentPreview()
}


