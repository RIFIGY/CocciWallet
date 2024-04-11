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
    @Environment(EthereumNetworkCard.self) private var card

    let nfts: [ERC721 : [NFT]]
    let address: EthereumAddress
    
    let favorite: NftEntity?
    let color: Color
    var imageSize: CGFloat = 160

    var cover: NFTMetadata? {
        guard let (contract, nfts) = nfts.first,
              let nft = nfts.first else {return nil}
        return .init(nft: nft, contract: contract)    }

        
    @State private var showNFTs = false
    @State private var showClaim = false
    @State private var metadata: [ERC721 : [NFTMetadata] ] = [:]
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
            NFTGridView(nfts: metadata)
//            NftListView(tokens: nfts.map{ [ $0.key : $0.value.map{} ] })
//                .environment(card)
        }
        .sheet(isPresented: $showClaim) {
            Text("Claim")
        }
        .task {
//            let storage = MetadataStorage()

            await withTaskGroup(of: Void.self) { group in
                for (contract, nfts) in self.nfts {
                    for nft in nfts {
                        group.addTask {
                            let nftMetadata = NFTMetadata(nft: nft, contract: contract)
                            await nftMetadata.fetch()
                            self.metadata[contract, default: []].append(nftMetadata)
                        }
                    }
                }
                
                // Process each result as it comes in
//                for await result in group {
//                    await storage.add(metadata: result.1, forContract: result.0)
//                }
            }

            // After all tasks are completed, update the shared state
            // Note: Access to `storage` is performed on the main actor if updating UI or other main-thread-only operations
//            let tokens = await storage.storage
//            self.metadata = tokens
//            print(self.metadata.count)
        }
    }
}

actor MetadataStorage {
    var storage: [ERC721: [NFTMetadata]] = [:]

    func add(metadata nftMetadata: NFTMetadata, forContract contract: ERC721) {
        storage[contract, default: []].append(nftMetadata)
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
