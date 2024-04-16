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
    
//    @Binding var selection: NetworkCardDestination?
    @Binding var selected: Network?

    var body: some View {
        if let card = selected {
            NetworkDetailView(card: card)
        } else {
            ContentUnavailableView("Select a Card", systemImage: "square")
        }
    }
}

//#Preview {
//    DetailCollumn(panel: .constant(.networks))
//}
