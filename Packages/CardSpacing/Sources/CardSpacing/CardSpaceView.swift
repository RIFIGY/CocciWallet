//
//  CardSpacingView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI


struct CardSpaceView<CardView:View> : View {
    let height: CGFloat
    let index: Int
    
    let offset: CGFloat
    var useDownOffset: Bool = true

    @ViewBuilder
    var cardView: CardView
        
    var body: some View {
        if useDownOffset {
            reader
        } else {
            cardView.frame(height: height)
        }
    }
    
    var reader: some View {
        GeometryReader { geometry in
            let minY = geometry.bounds(of: .scrollView)?.minY
            cardView
            .frame(height: height)
            .offset(y: localOffset(for: minY))
        }
        .frame(height: height)
    }
    
    private func localOffset(for minY: CGFloat?) -> CGFloat {
        let minY = minY ?? 0

        if offset > 0 { // scrolling items up
            if minY >= 0 { // item has reached top
                return minY // return items original minY to pin it
            } else {
                return 0 // item should flow with scroll
            }
        }
        else if useDownOffset { // scrolling items down
            let index = index + 1
            let modifier = CGFloat(index) * 0.15
            return offset - (offset * modifier)
        }
        else {
            return 0
        }

    }
}

//import Web3Kit
//#Preview {
//    CardSpacingView(cards: EVM.selection, cardHeight: 200, offset: 0) { evm in
//        NetworkCardView(wallet: .rifigy, evm: evm, nativeBalance: 0)
//    }
//}
