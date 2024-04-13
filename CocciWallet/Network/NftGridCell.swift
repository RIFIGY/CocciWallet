//
//  NftGridCell.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI
import WalletData
import Web3Kit

struct NftGridCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openWindow) private var openWindow
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows

    typealias NFT = WalletData.NFT

    let nfts: [ERC721 : [NFT]]
    let address: EthereumAddress
    
//    let favorite: NftEntity?
    let color: Color
    var imageSize: CGFloat = 160

    private var cover: NFT? {
        nfts.flatMap{$0.value}.first{$0.imageURL != nil }
//        nfts.first?.value.first{$0.imageURL != nil}
    }

        
    @State private var showClaim = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NFT \(nfts.flatMap{$0.value}.count)")
            Group {
                if let cover {
                    NFTImageView(nft: cover, contentMode: .fill)
                        .cellBackground(padding: 8, cornerRadius: 16)

                } else {
                    Button("Claim\nyour first \nNFT"){
//                        self.showClaim = true
                        if supportsMultipleWindows {
                            openWindow(id: NFTWindow.ID)
                        }
                    }
                        .foregroundStyle(color)
                        .font(.title.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .cellBackground(padding: 8, cornerRadius: 16)
                }
            }
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }

        .sheet(isPresented: $showClaim) {
            Text("Claim")
        }
        
    }
}

//actor MetadataStorage {
//    var storage: [ERC721: [NFT]] = [:]
//
//    func add(metadata nftMetadata: NFTMetadata, forContract contract: ERC721) {
//        storage[contract, default: []].append(nftMetadata)
//    }
//}
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
