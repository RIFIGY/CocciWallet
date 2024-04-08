//
//  NftGridCell.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI
import Web3Kit

struct NftGridCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(NetworkCard.self) private var card

    let model: NftVM<EthereumClient.Client>
    let favorite: NftEntity?
    let color: Color
    var imageSize: CGFloat = 160

    var cover: NFTMetadata? {
        model.coverNft(favorite: favorite)
    }

        
    @State private var showNFTs = false
    @State private var showClaim = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NFT")
            Group {
                if let cover {
                    NFTImageView(nft: cover, contentMode: .fill)
                        .onTapGesture {
                            self.showNFTs = true
                        }
                } else {
                    Button("Claim\nyour first \nNFT"){
                        self.showClaim = true
                    }
                        .foregroundStyle(color)
                        .font(.title.weight(.semibold))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .cellBackground(padding: 8, cornerRadius: 16)
        .navigationDestination(isPresented: $showNFTs) {
            NftListView(model: model)
                .environment(card)
        }
        .sheet(isPresented: $showClaim) {
            Text("Claim")
        }
    }
}


//#Preview("Cell"){
//    NftGridCell(model: .preview, favorite: .munko2309, color: .ETH)
//}

//#Preview("ScrollView") {
//    NavigationStack {
//        ScrollView(.vertical) {
//            VStack {
//                Grid{
//                    GridRow {
//                        NftGridCell(model: .preview, favorite: .munko2309, color: .ETH)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//        }
//        .background(Color.systemGray)
//    }
//}
