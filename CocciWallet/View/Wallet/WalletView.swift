//
//  WalletNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI
import Web3Kit
import BigInt
import CardSpacing

struct WalletView: View {
    @Environment(WalletHolder.self) private var manager
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var wallet: WalletModel
    @Binding var showSettings: Bool
    
    @State private var showNewNetwork = false
    @State private var showDetails = false
    @Namespace private var animation

    var body: some View {
        NetworkCardStack(
            wallet: wallet,
            animation: animation,
            showDetail: $showDetails,
            header: header,
            footer: footer,
            delete: remove
        )
        .sheet(isPresented: $showNewNetwork) {
            NavigationStack {
                AddNetworkView(showNewNetwork: $showNewNetwork)
                    .environment(priceModel)
                    .environment(wallet)
            }
        }

        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    func remove(network card: NetworkCard) {
        wallet.remove(card.evm)
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
            Text("Networks")
                .font(.largeTitle.weight(.bold))
            Spacer()
            HStack {
                HeaderButton(systemName: "wallet.pass") {
                    withAnimation {
    //                    manager.selected = nil
                    }
                }
                HeaderButton(systemName: "gear") {
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

