//
//  NftWidgetMedium.swift
//  WidgetsExtension
//
//  Created by Michael Wilkowski on 3/31/24.
//

import SwiftUI
import WidgetKit
import OffChainKit

struct MediumNftWidget: View {
    
    let nft: NFTEntity?
    let image: PlatformImage?
    let showBackground: Bool
    let symbol: String?
    
    var body: some View {
        HStack {
            SmallNFT(image: image, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            if let nft {
                VStack(alignment: .leading) {
                    Text(nft.contract.shortened())
                        .font(.title3)
                    Text("#\(nft.tokenId)")
                        .font(.title)
                    if let name = nft.name {
                        Text(name)
                    }
                }
                .font(.title3)
            }
            Spacer()
        }
        .foregroundStyle(showBackground ? .white : .primary)

    }
}

#Preview(as: .systemMedium) {
    NftWidgets()
} timeline: {
    NftEntry(date: .now, intent: .m2309)
    NftEntry(date: .now, intent: .m2310)
}
