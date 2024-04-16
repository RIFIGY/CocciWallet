////
////  CardScrollView.swift
////  CocciWallet
////
////  Created by Michael Wilkowski on 3/15/24.
////
//
//import SwiftUI
//
//public struct CardScrollView<Header:View, Card: Identifiable, CardView:View, Bottom:View>: View where Card.ID == String {
//    
//    var cardHeight: CGFloat = 200
//    var cardCount: Int { cards.count }
//    
//    var cards: [Card]
//    var additional: [Card] = []
//    @ViewBuilder
//    var cardView: (Card) -> CardView
//    
//    @ViewBuilder
//    var header: Header
//    
//    @ViewBuilder
//    var bottom: Bottom
//    
//    @State private var offset: CGPoint = .zero
//    private var spacing: CGFloat { cardHeight/2 * 1.4 }
//
//    public var body: some View {
//        OffsetObservingScrollView(axes: .vertical, showsIndicators: false, offset: $offset) {
//            VStack(spacing: 0) {
//                header
//                    .padding(.vertical)
//                    .padding(.top)
//                    .offset(y: headerOffset)
//                    .id("Header")
//                    .scrollTransition(.animated) { content, phase in
//                        content
//                            .opacity(phase != .identity ? 0.3 : 1)
//                    }
//                VStack(spacing: -spacing) {
//                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, item in
//                        CardSpaceView<CardView>(
//                            height: cardHeight,
//                            index: index,
//                            offset: offset.y,
//                            useDownOffset: true
//                        ) {
//                            cardView(item)
//                        }
//                    }
//                }
//
//                if !additional.isEmpty {
//                    LazyVStack(spacing: -spacing) {
//                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, item in
//                            CardSpaceView<CardView>(
//                                height: cardHeight,
//                                index: index,
//                                offset: offset.y,
//                                useDownOffset: offset.y >= (CGFloat(cards.count) * cardHeight/2)
//                            ) {
//                                cardView(item)
//                            }
//                        }
//                        .padding(.top, 42)
//                    }
//                }
//                bottom
//                .offset(y: bottomOffset)
//            }
//        }
//
//        .onChange(of: offset) { _, newValue in
//            print("Offet: \(newValue.y)")
//        }
//    }
//    
//    var headerOffset: CGFloat {
//        if offset.y <= 0 {
//            offset.y - (offset.y * (0.15))
//        } else if self.offset.y < 40 {
//            0
//        } 
//        else {
//            offset.y - 40
//        }
//    }
//        
//    
//    var bottomOffset: CGFloat {
//        if offset.y <= 0 {
//            0
//        } else if offset.y >= (CGFloat(cards.count - 1) * 60) {
//            self.offset.y - (CGFloat(cards.count - 1) * 60) // default top safe area
//        } else {
//            0
//        }
//    }
//}
//
//public extension CardScrollView {
//    init(cardHeight: CGFloat = 200, cards: [Card], @ViewBuilder cardView: @escaping (Card) -> CardView, @ViewBuilder bottom: () -> Bottom) where Header == EmptyView {
//        self.cardHeight = cardHeight
//        self.cards = cards
//        self.cardView = cardView
//        self.bottom = bottom()
//        self.header = EmptyView()
//    }
//    init(cardHeight: CGFloat = 200, cards: [Card], @ViewBuilder cardView: @escaping (Card) -> CardView) where Header == EmptyView, Bottom == EmptyView {
//        self.cardHeight = cardHeight
//        self.cards = cards
//        self.cardView = cardView
//        self.bottom = EmptyView()
//        self.header = EmptyView()
//    }
//}
//
////#Preview {
////    CardScrollView(cardHeight: 200) {
////        ForEach(1..<10) { i in
////            let color = Color.random
////            ZStack {
////                color
////                Text(i.description + color.description)
////            }
////        }
////        .padding(.horizontal)
////    }
////
////}
