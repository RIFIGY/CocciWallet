//
//  NFTWindow.swift
//  CocciWallet
//
//  Created by Michael on 4/12/24.
//

import SwiftUI
import BigInt
import Web3Kit
import WalletData
import SwiftData

struct NFTWindow: View {
    
    typealias NFT = WalletData.NFT
    
    @Query private var wallets: [Wallet]

    var networks: [EthereumNetworkCard] {
        wallets.flatMap{$0.networks}
    }
    
    var toke: [String] {
        networks.flatMap{$0.tokens.map{$0.address}}
    }
    
    var contracts: [String] {
        networks.flatMap{$0.nfts.map{$0.contract}}
    }
    
    var nfts: [NFT] {
        networks.flatMap{$0.nfts}
    }
    var nft: NFT? {
        nfts.first
    }
    
    
    var body: some View {
        VStack {
            if let nft {
                NFTImageView(nft: nft)
            } else {
                Color.indigo
                    .frame(width: 300, height: 300)
            }
        }
    }

}

extension NFTWindow {
    static let ID = "NFT_WINDOW"
}
#Preview {
    let preview = Preview()
    preview.addWallets([.rifigy])
    return NFTWindow()
        .environmentPreview(preview)
}
