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

    let wallet: Wallet
    @Binding var selected: Network?
    @State private var selection: Network?

    @Binding var showNewNetwork: Bool
    @Binding var showWallets: Bool
    @Binding var showSettings: Bool
    
    @Namespace var animation
    @State private var showDetail = false
    
    var body: some View {
        Group {
            if wallet.settings.displayAsCards {
                stack
            } else {
                NetworkList(networks: wallet.networks, selected: $selected, showNewNetwork: $showNewNetwork)
            }
        }
//        .navigationDestination(item: $selected) { card in
//            NetworkDetailView(card: card)
//        }
        .sheet(isPresented: $showNewNetwork) {
            NavigationStack {
                AddNetworkView(wallet: wallet)
            }
        }
    }
    
    var stack: some View {
        CardList(
            animation: animation,
            cards: wallet.networks.filter{!$0.isCustom}.sorted{$0.chain > $1.chain},
            additional: wallet.networks.filter{$0.isCustom},
            selected: $selection,
            header: header
        ) { card in
            NetworkCardView(card: card)
        } cardDetail: { card in
            NetworkDetailView(card: card)
                .navigationBarTitleDisplayMode(.inline)
        } cardIcon: { card in
            CardIcon(color: card?.color, symbol: card?.symbol)
        }


    }
    

    
    var footer: some View {
        Button("Add"){
            showNewNetwork = true
        }
        .buttonStyle(.bordered)
//        .padding(.vertical, 32)
    }

    var header: some View {
        HStack {
            Text(wallet.name)
                .font(.largeTitle.weight(.bold))
            Spacer()
            HStack {
//                HeaderButton(systemName: "wallet.pass") {
//                    withAnimation {
//                        showWallets = true
//                    }
//                }
                HeaderButton(systemName: "plus") {
                    showNewNetwork = true
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
