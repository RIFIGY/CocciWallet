//
//  NFTWidgetView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import SwiftUI
import WidgetKit
import OffChainKit

struct NFTWidgetView: View {
    @Environment(\.widgetFamily) private var family
    
    var entry: NftProvider.Entry
    
    var intent: NFTIntent { entry.intent }
    
    var nft: NftEntity? { intent.nft }
    var uiImage: UIImage? { entry.uiImage }

    var showBackground: Bool { intent.showBackground }
    
    var symbol: String? {
        intent.network?.symbol
    }
        
    var body: some View {
        Group {
            switch family {
            case .systemSmall: 
                SmallNFT(image: uiImage, contentMode: .fill)
            case .systemMedium:
                MediumNftWidget(
                    nft: nft,
                    image: uiImage,
                    showBackground: showBackground,
                    symbol: symbol
                )
            case .systemLarge:
                LargeNFT(
                    nft: nft,
                    image: uiImage,
                    nfts: entry.intent.nfts ?? [],
                    images: entry.images,
                    symbol: symbol,
                    showBackground: showBackground
                )
            default:
                NFTImageView(image: uiImage)
            }
        }
        .overlay(alignment: .topTrailing) {
            if entry.intent.showNetwork {
                IconImage(symbol: symbol ?? "", size: 32, glyph: showBackground ? .white : nil)
                    .padding([.top, .trailing])
            }
        }
        .containerBackground(for: .widget) {
            if showBackground {
                Icon(symbol: symbol)?.color
            }
        }
        

    }

}

struct NftWidgets: Widget {
    let kind: String = "NFT Widgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: NFTIntent.self, provider: NftProvider()) { entry in
            NFTWidgetView(entry: entry)
        }
        .configurationDisplayName("NFT Widget")
        .description("Display your owned NFTs")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}



#Preview(as: .systemSmall) {
    NftWidgets()
} timeline: {
    NftEntry(date: .now, intent: .m2309, uiImage: .munko2309)
    NftEntry(date: .now, intent: .m2310, uiImage: .munko2309)
}
