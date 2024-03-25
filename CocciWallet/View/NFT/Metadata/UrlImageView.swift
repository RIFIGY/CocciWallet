//
//  ERC721ImageView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/7/24.
//

import SwiftUI

typealias NFTImageView = UrlImageView

struct UrlImageView<P:View>: View {
    @Environment(\.colorScheme) var colorScheme

    let url: URL?
    let image: PlatformImage?
    var isCell: Bool = false
    
    var gateway: URL? {
        url
    }
    
    @ViewBuilder let placeholder: P
    
    var body: some View {
        Group {
            if let image {
                Group {
                    #if canImport(UIKit)
                    Image(uiImage: image).resizable()
                    #elseif canImport(AppKit)
                    Image(nsImage: image).resizable()
                    #endif
                }
                .aspectRatio(contentMode: isCell ? .fill : .fit)
            } else {
                AsyncImage(url: gateway) { image in
                    image.resizable()
                        .aspectRatio(contentMode: isCell ? .fill : .fit)
                } placeholder: {
                    placeholder
                }
            }
        }
    }
}


extension UrlImageView {
    
    init(
        url: URL?,
        image: PlatformImage? = nil,
        isCell: Bool = false,
        placeholder: Color = .secondary
    )
        where P == ZStack<TupleView<(_ShapeView<Rectangle, Color>,ProgressView<EmptyView, EmptyView>)>>
    {
        self.placeholder = ZStack {Rectangle().fill(placeholder);ProgressView() }
        self.url = url
        self.image = image
        self.isCell = isCell
    }
}

//#Preview {
//    ERC721ImageView(data: ERC721.Token.muko2309JSON)
//}

//fileprivate extension ERC721ImageView {
//    init(data: Data?, uiImage: UIImage? = nil, isCell: Bool = false, placeholder: Color = .secondary) where P == ZStack<TupleView<(_ShapeView<Rectangle, Color>,ProgressView<EmptyView, EmptyView>)>> {
//        self.placeholder = ZStack {Rectangle().fill(placeholder);ProgressView() }
//        var opensea: OpenSeaMetadata? {
//            try? JSONDecoder().decode(OpenSeaMetadata.self, from: data ?? Data())
//        }
//        
//        var url: URL? {
//            let url = URL(string: opensea?.image ?? "")
//            guard let url else {return nil}
//            return IPFS.gateway(uri: url)
//        }
//        self.uiImage = uiImage
//        self.url = url
//        self.isCell = isCell
//    }
//}
