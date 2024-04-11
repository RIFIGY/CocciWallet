//
//  WalletNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI
import WalletData
import OffChainKit

struct WalletView: View {
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"

    @Bindable var wallet: Wallet
    @Binding var showSettings: Bool
    @Binding var showWallets: Bool

    @State private var showNewNetwork = false
    @Namespace private var animation

    var body: some View {
        Group {
            #if os(iOS)
            if wallet.settings.displayAsCards {
                NetworkCardStack(
                    networks: $wallet.networks,
                    animation: animation,
                    header: header,
                    footer: footer
                ) { card in
                    await update(card: card)
                }
            } else {
                cardList
            }
            #else
            cardList
            #endif
        }
        .sheet(isPresented: $showNewNetwork) {
            AddNetworkView(address: wallet.address) { network in
                if !wallet.networks.map({$0.id}).contains(network.id) {
                    wallet.networks.append(network)
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
            
    var cardList: some View {
        NetworkCardList(
            wallet: wallet,
            showSettings: $showSettings,
            showNewNetwork: $showNewNetwork,
            showWallets: $showWallets
        )
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
            Text(wallet.name)
                .font(.largeTitle.weight(.bold))
            Spacer()
            HStack {
                HeaderButton(systemName: "wallet.pass") {
                    withAnimation {
                        showWallets = true
                    }
                }
                HeaderButton(systemName: "gearshape") {
                    showSettings = true
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func update(card: EthereumNetworkCard) async {
        
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



#Preview {
    let preview = Preview()
    return WalletView(wallet: .rifigy, showSettings: .constant(false), showWallets: .constant(false))
        .environmentPreview()
}

