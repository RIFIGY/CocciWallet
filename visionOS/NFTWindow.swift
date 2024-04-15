//
//  NFTWindow.swift
//  CocciWallet
//
//  Created by Michael on 4/12/24.
//

import SwiftUI
import BigInt
import Web3Kit

import SwiftData

struct NFTWindow: View {
    
    @Binding var nft: NFTEntity
//    @Query private var wallets: [Wallet]
//    
//    var networks: [Network] {
//        wallets.flatMap{$0.networks}
//    }
//    
//    var toke: [String] {
//        networks.flatMap{$0.tokens.map{$0.address}}
//    }
//    
//    var contracts: [String] {
//        networks.flatMap{$0.nfts.map{$0.contract}}
//    }
//    
//    var nfts: [NFT] {
//        networks.flatMap{$0.nfts}
//    }
//    var nft: NFT? {
//        nfts.first
//    }
    
    
    var body: some View {
        VStack {
            NFTImageView(nft: nft)
        }
    }

}

extension NFTWindow {
    static let ID = "NFT_WINDOW"
}
//#Preview {
//    let preview = Preview()
//    preview.addWallets([.rifigy])
//    return NFTWindow()
//        .environmentPreview(preview)
//}
