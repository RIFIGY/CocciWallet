//
//  DetailCollumn.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit
import SwiftData

struct DetailCollumn: View {
    @Environment(\.modelContext) private var context
    
    let walletSelected: Bool
    @Binding var selected: EthereumNetworkCard?
    
    var body: some View {
        Group {
            if !walletSelected {
                ContentUnavailableView("Select a Network", systemImage: "circle")
            } else if let selected  {
                NetworkDetailView(card: selected)
            } else {
                ContentUnavailableView("Select a Network", systemImage: "circle")
            }
        }
    }
}

//#Preview {
//    DetailCollumn(panel: .constant(.networks))
//}
