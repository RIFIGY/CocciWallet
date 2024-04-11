/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The grid view used in the DonutGallery.
*/

import SwiftUI

struct NFTGalleryGrid: View {
    var nfts: [NFTMetadata]
    var width: Double
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
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
                NavigationLink {
                    NFTDetail(nft: nft)
                } label: {
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
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

//struct DonutGalleryGrid_Previews: PreviewProvider {
//    struct Preview: View {
//        @State private var donuts = Donut.all
//        
//        var body: some View {
//            GeometryReader { geometryProxy in
//                ScrollView {
//                    DonutGalleryGrid(donuts: donuts, width: geometryProxy.size.width)
//                }
//            }
//        }
//    }
//    
//    static var previews: some View {
//        Preview()
//    }
//}
