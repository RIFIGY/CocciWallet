//
//  CardView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI

public struct CardView<TopLeading:View, TopTrailing:View, BottomLeading:View, BottomTrailing:View>: View {
    let color: Color
    var height: CGFloat?
    var cornerRadius: CGFloat
    
    @ViewBuilder
    var topLeading: TopLeading
    
    @ViewBuilder
    var topTrailing: TopTrailing
    
    @ViewBuilder
    var bottomLeading: BottomLeading
    
    @ViewBuilder
    var bottomTrailing: BottomTrailing
    
    public var body: some View {
        ZStack {
            color
            VStack {
                HStack  {
                    topLeading
                    Spacer()
                    topTrailing
                }
                .padding()
                Spacer()
                HStack {
                    bottomLeading
                    Spacer()
                    bottomTrailing
                }
                .padding()
            }
            .foregroundStyle(.white)
        }
        .optional(height) { view, height in
            view.frame(height: height)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension CardView {
    public init(
        color: Color,
        height: CGFloat? = nil,
        cornerRadius: CGFloat? = 16,
        header topLeading: String,
        subHeader topTrailing: String = "",
        footer bottomLeading: String = "",
        subFoot bottomTrailing: String = ""
    ) where TopLeading == Text, TopTrailing == Text, BottomLeading == Text, BottomTrailing == Text {
        self.color = color
        self.cornerRadius = cornerRadius ?? 0
        self.height = height
        self.topLeading = Text(topLeading)
        self.topTrailing = Text(topTrailing)
        self.bottomLeading = Text(bottomLeading)
        self.bottomTrailing = Text(bottomTrailing)
    }
    
    public init(
        color: Color,
        height: CGFloat? = nil,
        cornerRadius: CGFloat? = 16,
        @ViewBuilder topLeading: () -> TopLeading,
        @ViewBuilder topTrailing: () -> TopTrailing,
        @ViewBuilder bottomLeading: () -> BottomLeading,
        @ViewBuilder bottomTrailing: () -> BottomTrailing
    ) {
        self.color = color
        self.cornerRadius = cornerRadius ?? 0
        self.topLeading = topLeading()
        self.topTrailing = topTrailing()
        self.bottomLeading = bottomLeading()
        self.bottomTrailing = bottomTrailing()
    }
}

#Preview {
    CardView(color: .random, header: "Header")
}
