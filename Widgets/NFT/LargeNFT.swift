//
//  NftWidgetLarge.swift
//  WidgetsExtension
//
//  Created by Michael Wilkowski on 3/31/24.
//

import SwiftUI
import WidgetKit
import Web3Kit

struct LargeNFT: View {
    typealias Attribute = OpenSeaMetadata.Attribute

    let nft: NftEntity?
    let image: PlatformImage?
    
    var metadata: OpenSeaMetadata? { nft?.opensea }
    
    let nfts: [NftEntity]
    let images: [PlatformImage?]
    let symbol: String?
    let showBackground: Bool
    
    var showGrid: Bool {
        (nfts.count == 2 && images.count == 2) ||
        (nfts.count == 4 && images.count == 4)
    }
    
    var body: some View {
        if showGrid {
            LazyHGrid(rows: .init(repeating: .init(.flexible(), spacing: 0), count: 2), spacing: 0) {
                ForEach(0..<nfts.count, id: \.self) { i in
                    if nfts.count == 2 {
                        MediumNftWidget(
                            nft: nfts[i],
                            image: images[i],
                            showBackground: showBackground,
                            symbol: symbol
                        )
                        .padding(.trailing, 36)
                    } else {
                        NFTImageView(image: images[i])
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                }
            }
        } else {
            VStack {
                MediumNftWidget(
                    nft: nft,
                    image: image,
                    showBackground: showBackground,
                    symbol: symbol
                )
                if let description = metadata?.description {
                    Text(description)
                        .padding(.horizontal)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                attributeGrid2
            }
        }
    }
    
    @ViewBuilder
    var attributeGrid2: some View {
        if let attributes = metadata?.attributes {
            let attributes = Array(attributes.prefix(8))
            AttributeGrid(attributes, columns: 4) { title, any in
                AttributeCell(name: title, value: any, size: .init(width: 70, height: 50))
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    var attributeGrid: some View {
        if let attributes = metadata?.attributes {
            LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 4)) {
                ForEach(Array(attributes.prefix(8)), id: \.self.traitType) { item in
                    VStack{
                        Text(item.traitType)
                            .font(.caption)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.3)
                        Group {
                            switch item.value  {
                            case .string(let string):
                                Text(string)
                            case .int(let int):
                                Text(int, format: .number)
                            case .double(let double):
                                Text(double, format: .number.precision(.fractionLength(2)))
                            }
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    }
//                        .padding(8)
                    .padding(.horizontal, 2)
                    .frame(width: 70, height: 50)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }

            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}

#Preview(as: .systemLarge) {
    NftWidgets()
} timeline: {
    NftEntry(date: .now, intent: .m2310, uiImage: .munko2309)
    NftEntry(date: .now, intent: .m2309, uiImage: .munko2309)
    NftEntry(date: .now, intent: .m2309_2, images: [ .munko2309, .munko2309 ])
    NftEntry(date: .now, intent: .m2309_4, images: [ .munko2309, .munko2309, .munko2309, .munko2309 ])
}
