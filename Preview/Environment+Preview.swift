//
//  WalletModel+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation
import Web3Kit
import SwiftData

import SwiftUI
extension View {
    
    @ViewBuilder
    func environmentPreview(_ preview: Preview = Preview()) -> some View {
        self
            .environment(PriceModel.preview)
            .environment(NetworkManager())
            .environment(Navigation.preview)
            .modelContainer(preview.container)
    }
}
struct Preview {
    
    let container: ModelContainer
    
    init(){
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Wallet.self, Network.self, Token.self, NFT.self, configurations: config)
        self.container = container
    }
    
    func addWallets(_ wallets: [Wallet]) {
        Task { @MainActor in
            wallets.forEach { wallet in
                container.mainContext.insert(wallet)
            }
        }
    }
    
}
