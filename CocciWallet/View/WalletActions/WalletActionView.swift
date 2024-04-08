//
//  WalletActionView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI
import Web3Kit


enum WalletAction: String, Hashable, Identifiable, Equatable {
    var id: String { rawValue }
    case receive, send, swap, stake
    
    static let active: [WalletAction] = [.receive, .send, .swap, .stake]
    
    var title: String { rawValue.capitalized }
    var systemName: String {
        switch self {
        case .receive:
            "arrow.down"
        case .send:
            "arrow.up"
        case .stake:
            "banknote"
        case .swap:
            "rectangle.2.swap"
        }
    }
}

extension WalletAction {
    
    struct GridButton: View {
        @Environment(WalletHolder.self) private var manager
        @Environment(NetworkManager.self) private var network
        
        let destination: WalletAction
        let card: NetworkCard
        var address: String { card.address }
        var size: CGFloat = 164
        
        init(_ destination: WalletAction, card: NetworkCard, size: CGFloat = 164) {
            self.destination = destination
            self.card = card
            self.size = size
        }
        var color: Color { card.color }
        var decimals: UInt8 { card.decimals }
        
        @State private var showDestination = false
        
        var body: some View {
            GridCell.Button(title: destination.title, systemName: destination.systemName, size: size) {
                showDestination = true
            }
            .sheet(isPresented: $showDestination) {
                NavigationStack {
                    Group {
                        switch destination {
                        case .receive: AddressView(address: address, name: card.name)
                        case .send: WalletSendView(address: address, card: card, decimals: decimals)
                        case .swap: SwapView()
                        case .stake: StakeView()
                        }
                    }
                    .environment(manager)
                    .environment(network)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(systemName: "chevron.left") {
                                self.showDestination = false
                            }
                            .foregroundStyle(color)
                        }
                    }
                    .toolbarRole(.editor)
                }
            }
        }
    }
    

}
