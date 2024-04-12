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
//        @Environment(WalletHolder.self) private var manager
        @Environment(NetworkManager.self) private var network
        
        let destination: WalletAction
//        let card: NetworkCard
        
        var name: String
        var color: Color
        var decimals: UInt8
        
        #warning("fix this to pass address")
        let address: EthereumAddress = .init("")
        var size: CGFloat = 164
        
        init(_ destination: WalletAction, card: EthereumNetworkCard, size: CGFloat = 164) {
            self.destination = destination
            self.name = card.name
            self.color = card.color
            self.decimals = card.decimals
            self.size = size
        }

        
        @State private var showDestination = false
        
        var body: some View {
            GridCell.Button(title: destination.title, systemName: destination.systemName, size: size) {
                showDestination = true
            }
            .sheet(isPresented: $showDestination) {
                NavigationStack {
                    Group {
                        switch destination {
                        case .receive: AddressView(address: address.string, name: name)
                        case .send: Text("Send")//WalletSendView(address: address, card: card, decimals: decimals)
                        case .swap: SwapView()
                        case .stake: StakeView()
                        }
                    }
//                    .environment(manager)
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

extension GridCell.Button {
    init(_ destination: WalletAction, color: Color, size: CGFloat = 164, action: @escaping () -> Void) {
        self.title = destination.title
        self.systemName = destination.systemName
        self.size = size
        self.action = action
    }
}
