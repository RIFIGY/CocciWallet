//
//  WalletActionView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI
import Web3Kit

struct WalletActionView: View {
    @Environment(WalletHolder.self) private var manager
    @Environment(NetworkManager.self) private var network
    
    let evm: EVM
    var color: Color { evm.color }
    
    let address: String
    var size: CGFloat = 164

    @State private var selected: Destination?
    
    var body: some View {
        HStack{

            Button {
                self.selected = .receive
            } label: {
                VStack {
                    Text(Destination.receive.title)
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                    Image(systemName: Destination.receive.systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size/3)
                        .padding()
                        .overlay(
                            Circle()
                                .stroke(color, lineWidth: 4)
                        )
                }
                .foregroundStyle(color)
                .fontWeight(.semibold)
                .frame(width: size, height: size)
            }
            .padding(.leading)
            .cellBackground(cornerRadius: 16)
            VStack {
                GridButton(.send)
                GridButton(.swap)
            }

        }
        #if os(iOS)
        .sheet(item: $selected) { destination in
            NavigationStack {
                Group {
                    switch destination {
                    case .receive: QRCodeView(address)
                    case .send: WalletSendView(address: address, evm: evm, decimals: 18)
                    default: QRCodeView(address)
                    }
                }
                .environment(manager)
                .environment(network)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(systemName: "chevron.left") {
                            self.selected = nil
                        }
                        .foregroundStyle(color)
                    }
                }
                .toolbarRole(.editor)
            }
        }
        #endif
    }
    
    private func GridButton(_ destination: WalletActionView.Destination) -> some View {
        Button {
            self.selected = destination
        } label: {
            HStack {
                Image(systemName: destination.systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: size/4)
                    .padding(destination == .swap ? 12 : 8)
                    .overlay(
                        Circle()
                            .stroke(color, lineWidth: 2)
                    )

                Text(destination.title)
//                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                Spacer()
            }
            .foregroundStyle(color)
            .fontWeight(.semibold)
//            .frame(height: size/2)
        }
        .cellBackground(padding: 16, cornerRadius: 16)

    }
    
    private func CircleButton(destination: WalletActionView.Destination) -> some View {
        Button{
            self.selected = destination
        } label: {
            VStack {
                Text(destination.title)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                Image(systemName: destination.systemName)
            }
            .foregroundStyle(color ?? .ETH)
            .fontWeight(.semibold)
            .frame(width: size, height: size)
            .background(.white)
            .clipShape(.buttonBorder)
//                .cornerRadius(.infinity)
        }
    }
    
    
    enum Destination: String, Hashable, Identifiable, Equatable {
        var id: String { rawValue }
        case receive, send, buy, sell, swap
        
        static let active: [Destination] = [.receive, .send, .swap]
        
        var title: String { rawValue.capitalized }
        var systemName: String {
            switch self {
            case .receive:
                "arrow.down"
            case .send:
                "arrow.up"
            case .buy:
                "creditcard"
            case .sell:
                "banknote"
            case .swap:
                "rectangle.2.swap"
            }
        }
    }
    

}

#Preview {
    WalletActionView(evm: .ETH, address: Wallet.rifigy.address)
        .background(Color.ETH)
}
