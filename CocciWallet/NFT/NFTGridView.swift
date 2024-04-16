/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The grid view used in the DonutGallery.
*/

import SwiftUI


struct NFTGridView: View {
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    @Environment(\.openWindow) private var openWindow
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    
    var nfts: [NFT]
    var width: Double
    var group: Bool
    var onTap: ((NFT) -> Void)? = nil
    
    var grouped: [String : [NFT] ] {
        Dictionary(grouping: nfts, by: {$0.contract})
    }
    
    var contracts: [String] {
        grouped.keys.map{$0}
    }
    
    var useReducedThumbnailSize: Bool {
        #if os(iOS)
        if sizeClass == .compact {
            return true
        }
        #endif
        if dynamicTypeSize >= .xxxLarge {
            return true
        }
        
        #if os(iOS)
        if width <= 390 {
            return true
        }
        #elseif os(macOS)
        if width <= 520 {
            return true
        }
        #endif
        
        return false
    }
    
    var cellSize: Double {
        useReducedThumbnailSize ? 100 : 150
    }
    
    var thumbnailSize: Double {
        #if os(iOS)
        return useReducedThumbnailSize ? 60 : 100
        #else
        return useReducedThumbnailSize ? 40 : 80
        #endif
    }
    
    var gridItems: [GridItem] {
        [GridItem(.adaptive(minimum: cellSize), spacing: 10, alignment: .top)]
    }
    
    var body: some View {
        if group {
            VStack {
                ForEach(grouped.keys.map{$0}, id: \.self) { contract in
                    if let nfts = grouped[contract] {
                        Section(contract) {
                            LazyVGrid(columns: gridItems, spacing: 10) {
                                ForEach(nfts) { nft in
                                    Cell(nft: nft, thumbnailSize: thumbnailSize)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        } else {
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(nfts) { nft in
                    Cell(nft: nft, thumbnailSize: thumbnailSize)
                }
            }
            .padding()
        }
    }
    
    struct Cell: View {
        let nft: NFT
        let thumbnailSize: Double
        var onTap: ((NFT) -> Void)? = nil

        var cell: some View {
            VStack {
                NFTImageView(nft: nft.token, contentMode: .fit)
                    .frame(width: thumbnailSize, height: thumbnailSize)

                VStack {
                    Text(nft.title)
//                            HStack(spacing: 4) {
//                                flavor.image
//                                Text(flavor.name)
//                            }
//                            .font(.subheadline)
//                            .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
            }
        }
        
        var body: some View {
            if let onTap {
                cell
                    .onTapGesture{
                        onTap(nft)
                    }
            } else {
                #if os(visionOS)
                Button {
                    openWindow(id: NFTWindow.ID, value: nft.token)
                } label: {
                    cell
                }
                #else
                NavigationLink {
                    NFTDetail(nft: nft)
                } label: {
                    cell
                }
                .buttonStyle(.plain)
                #endif
            }
        }
    }
}

#Preview {
    GeometryReader { geometryProxy in
        ScrollView {
            NFTGridView(nfts: [.init(token: .munko2309)], width: geometryProxy.size.width, group: true)
        }
    }
}
