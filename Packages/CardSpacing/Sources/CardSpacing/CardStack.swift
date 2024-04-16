//
//  CardStack.swift
//  CardList
//
//  Created by Michael Wilkowski on 3/22/24.
//

import SwiftUI

struct CardStack<C:Identifiable, CardView:View, Header: View, Footer: View>: View {
    let animation: Namespace.ID

    let cards: [C]
    let additional: [C]
    let height: CGFloat
    

    @Binding var currentCard: C?
    
    var header: Header
    var footer: Footer?
    
    @ViewBuilder var cardView: (C) -> CardView

    
    @State private var offset: CGPoint = .zero
    
    var showDetailCard: Bool { currentCard != nil }
    
    var body: some View {
        OffsetObservingScrollView(offset: $offset) {
            header
                .offset(y: localOffset(index: 0, for: 0))
            Stack(cards: cards)
            Stack(cards: additional, isAdditional: true)
            GeometryReader { geometry in
                let minY = geometry.bounds(of: .scrollView)?.minY
                footer
                    .opacity(!showDetailCard ? 1 : 0)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, showDetailCard ? 0 : 32)
                    .offset(y: transitionOffset(index: cards.count, for: minY))
            }
            Rectangle().fill(Color.clear).frame(height: 100)
        }
        .scrollContentBackground(.hidden)
    }
    

    @ViewBuilder
    func Stack(cards: [C], isAdditional: Bool = false) -> some View {
        VStack(spacing: -140){
            ForEach(cards){ card in
                GeometryReader { geometry in
                    let minY = geometry.bounds(of: .scrollView)?.minY
                    let index = getIndex(Card: card)
                    cardView(card)
                        .matchedGeometryEffect(id: card.id, in: animation)
                        .offset(y: localOffset(index: index, for: minY, isAdditional: isAdditional))
                        .offset(y: transitionOffset(index: index, for: minY) )
                }
                .frame(height: height)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.35)){
                        self.currentCard = card
                    }
                }
            }
        }
    }
    
    private func transitionOffset(index: Int, for minY: CGFloat?, custom: Bool = false) -> CGFloat {
        guard let currentCard, showDetailCard else { return 0 }
        let cardIndex = custom ? index + cards.count : index
        let selectedIndex = getIndex(Card: currentCard)
        
        guard cardIndex != selectedIndex else {return 0 }
        
        if cardIndex < selectedIndex {
            let topBoundary: CGFloat = minY ?? 0
//            let distanceAboveSelectedCard = CGFloat(selectedIndex - cardIndex) * (height)
            let offset = max(-height, topBoundary)
            return offset
        } else {
            return height
        }
    }
    
    private func localOffset(index: Int, for minY: CGFloat?, isAdditional: Bool = false) -> CGFloat {
        guard !isAdditional else {return 0}
        let minY = minY ?? 0

        if offset.y > 0 { // scrolling items up
            if minY >= 0 { // item has reached top
                return minY // return items original minY to pin it
            } else {
                return 0 // item should flow with scroll
            }
        }
        else if true { // scrolling items down
            let index = index + 1
            let modifier = CGFloat(index) * 0.15
            return offset.y - (offset.y * modifier)
        }
        else {
            return 0
        }

    }
    
    // Retreiving Index
    func getIndex(Card: C)->Int{
        return cards.firstIndex { currentCard in
            return currentCard.id == Card.id
        } ?? 0
    }
}

//#Preview {
//    VStack {
//        CardStack(cards: Card.cards, height: 200, animation: Namespace().wrappedValue, currentCard: .constant(nil), showDetailCard: .constant(false))
//    }
//}
