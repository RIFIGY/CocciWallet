//
//  WalletNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI

struct WalletView: View {
    @Environment(WalletHolder.self) private var manager
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var wallet: Wallet
    @Binding var showSettings: Bool
    
    @State private var showNewNetwork = false
    @State private var showWallets = false
    @Namespace private var animation

    var body: some View {
        Group {
            if wallet.settings.displayAsCards {
                NetworkCardStack(
                    wallet: wallet,
                    animation: animation,
                    header: header,
                    footer: footer,
                    delete: wallet.remove
                )
            } else {
                NetworkCardList(
                    wallet: wallet,
                    showSettings: $showSettings,
                    showNewNetwork: $showNewNetwork,
                    showWallets: $showWallets
                )
            }
        }
        .sheet(isPresented: $showNewNetwork) {
            AddNetworkView(wallet: wallet)
                .environment(priceModel)
        }
        .sheet(isPresented: $showWallets) {
            NavigationStack {
                SelectWalletView()
                    .environment(manager)
            }
                .presentationDetents([.medium, .large])
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
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
    //                    manager.selected = nil
                    }
                }
                HeaderButton(systemName: "gearshape") {
                    showSettings = true
                }
            }
        }
        .padding(.horizontal)
    }
}


struct HeaderButton: View {
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
    WalletView(wallet: .rifigy, showSettings: .constant(false))
        .environment(WalletHolder.preview )
}

