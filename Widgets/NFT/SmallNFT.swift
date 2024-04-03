//
//  SmallNFT.swift
//  WidgetsExtension
//
//  Created by Michael Wilkowski on 3/31/24.
//

import SwiftUI
import WidgetKit

typealias SmallNFT = NFTImageView


#Preview(as: .systemSmall) {
    NftWidgets()
} timeline: {
    NftEntry(date: .now, intent: .m2309, uiImage: .munko2309)
    NftEntry(date: .now, intent: .m2310, uiImage: .munko2309)
}
