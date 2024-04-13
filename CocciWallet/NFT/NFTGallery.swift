/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The grid view used in the DonutGallery.
*/

import SwiftUI
import WalletData

struct NFTGallery: View {

    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    @Environment(\.openWindow) private var openWindow
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    
    var nfts: [NFT]
    var width: Double
    
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
        [GridItem(.adaptive(minimum: cellSize), spacing: 20, alignment: .top)]
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 20) {
            ForEach(nfts) { nft in
                if supportsMultipleWindows {
                    Button {
                        openWindow(id: NFTWindow.ID)
                    } label: {
                        Cell(nft: nft, thumbnailSize: thumbnailSize)
                    }
                } else {
                    NavigationLink {
                        NFTDetail(nft: nft)
                    } label: {
                        Cell(nft: nft, thumbnailSize: thumbnailSize)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
    }
    
    struct Cell: View {
        let nft: WalletData.NFT
        let thumbnailSize: Double
        var body: some View {
            VStack {
                NFTImageView(nft: nft, contentMode: .fit)
                    .frame(width: thumbnailSize, height: thumbnailSize)

                VStack {
                    Text(nft.metadata?.name ?? "Name")
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
    }
}

#Preview {
    GeometryReader { geometryProxy in
        ScrollView {
            NFTGallery(nfts: [], width: geometryProxy.size.width)
        }
    }
}
