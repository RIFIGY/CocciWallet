//
//  NetworkDetailView.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit
import SwiftData
struct NetworkDetailView: View {
    let card: Network
    
    var saved: ()->Void = {}
    var removed: ()->Void = {}

    
    var address: EthereumAddress { card.address }
    
    @State private var showSettings = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                NetworkCardView(card: card)
                    .frame(height: 200)
                    .frame(minHeight: 200)
                    .frame(maxWidth: 600)
                    .padding(.horizontal)
                NetworkGridView(card: card)
            }
        }
        .systembackground()
        .navigationTitle(card.name)
        .toolbar{
            ToolbarItem(placement: .automatic) {
                Button("Settings", systemImage: "gearshape") {
                    showSettings = true
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                NetworkSettings(card: card, remove: removed)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back", systemImage: "chevron.left") {
                            showSettings = false
                        }
                    }
                }
            }
        }
    }

}



//
//#Preview {
//    NavigationStack {
//        NetworkDetailView(card: .preview)
//            .environmentPreview()
//    }
//}
