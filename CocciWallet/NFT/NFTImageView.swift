//
//  ERC721ImageView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/7/24.
//

import SwiftUI
import OffChainKit
#if canImport(SDWebImage)
import SDWebImageSwiftUI
#endif

struct NFTImageView<P:View>: View {
    @Environment(\.colorScheme) var colorScheme

    let url: URL?
    let image: PlatformImage?
    var contentMode: ContentMode = .fit
    
    var gateway: URL? {
        guard let url else {return nil}
        return IPFS.Gateway(url)
    }
    
    var placeholder: P? = nil
    
    var background: Color {
        colorScheme == .light ? .white : .secondary
    }
    
    @ViewBuilder
    var imagePlaceholder: some View {
        if let placeholder {
            placeholder
        } else {
            ZStack {
                Rectangle().fill(background)
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    var asyncImage: some View {
        AsyncImage(url: gateway) { image in
            image.resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            imagePlaceholder
        }
    }
    
    #if canImport(SDWebImage)
    @ViewBuilder
    var webImage: some View {
        WebImage(url: gateway) { image in
            image.resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            imagePlaceholder
        }
        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
//        .onSuccess { image, data, cacheType in}
        .indicator(.activity) // Activity Indicator
        .transition(.fade(duration: 0.5)) // Fade Transition with duration
//        .scaledToFit()
//        .frame(width: 300, height: 300, alignment: .center)
    }
    #endif

    
    var body: some View {
        if let image {
            Group {
                #if canImport(UIKit)
                Image(uiImage: image).resizable()
                #elseif canImport(AppKit)
                Image(nsImage: image).resizable()
                #endif
            }
            .aspectRatio(contentMode: contentMode)
        } 
        else if let gateway {
            webImage
//            #if canImport(SDImageSwiftUI)
//            webImage
//            #else
//            asyncImage
//            #endif
        }
        else {
            Image(systemName: "circle")
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .padding()
                .background(Color.purple)
        }
    }
}



extension NFTImageView {
    init(url: URL?, contentMode: ContentMode = .fit) where P == EmptyView {
        self.url = url
        self.image = nil
        self.placeholder = nil
        self.contentMode = contentMode
    }
    
    init(data: Data, contentMode: ContentMode = .fit) where P == EmptyView {
        self.url = nil
        self.image = PlatformImage(data: data)
        self.placeholder = nil
        self.contentMode = contentMode
    }
    
    init(image: PlatformImage?, contentMode: ContentMode = .fit) where P == EmptyView {
        self.url = nil
        self.image = image
        self.placeholder = nil
        self.contentMode = contentMode
    }
}

import Web3Kit
extension NFTImageView {
    init(nft: NFT, contentMode: ContentMode = .fit) where P == EmptyView {
//        if let image = nft.image {
//            self.image = image
//            self.url = nil
//        } else {
//            self.url = nft.imageURL
//            self.image = nil
//        }
        self.url = nft.token.imageURL
        self.image = nil
        self.contentMode = contentMode
        self.placeholder = nil
    }
    
    init(nft: NFTEntity, contentMode: ContentMode = .fit) where P == EmptyView {
        self.url = nft.imageURL
        self.image = nil
        self.contentMode = contentMode
        self.placeholder = nil
    }
}


//#Preview("NFT") {
//    NFTImageView(nft: .munko2309)
//}
//
//#Preview("URL") {
//    NFTImageView(url: .image2309)
//}
//
//


