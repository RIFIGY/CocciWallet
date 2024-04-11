//
//  ERC721ImageView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/7/24.
//

import SwiftUI
import OffChainKit

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
        colorScheme == .light ? .white :.systemGray
    }
    
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
        } else if let gateway {
            AsyncImage(url: gateway) { image in
                image.resizable()
                    .aspectRatio(contentMode: contentMode)
            } placeholder: {
                if let placeholder {
                    placeholder
                } else {
                    ZStack {
                        Rectangle().fill(background)
                        ProgressView()
                    }
                }
            }
        } else {
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

extension NFTImageView {
    init(nft: NFTMetadata, contentMode: ContentMode = .fit) where P == EmptyView {
        if let image = nft.image {
            self.image = image
            self.url = nil
        } else {
            self.url = nft.imageURL
            self.image = nil
        }
        self.contentMode = contentMode
        self.placeholder = nil
    }
}

#Preview("NFT") {
    NFTImageView(nft: .munko2309)
}

#Preview("URL") {
    NFTImageView(url: NFTMetadata.munko2309.imageURL)
}

#Preview("UIImage") {
    NFTImageView(image: .munko2309)
}
