//
//  CardListView.swift
//  CardList
//
//  Created by Michael Wilkowski on 3/22/24.
//

import SwiftUI

public struct CardList<C:Identifiable, CardView: View, CardDetails: View, CardIcon: View, Header: View, Footer: View>: View {
    
    let animation: Namespace.ID

    let cards: [C]
    let additional: [C]
    @Binding var selected: C?

    @ViewBuilder var cardView: (C) -> CardView
    @ViewBuilder var cardDetail: (C) -> CardDetails
    @ViewBuilder var cardIcon: (C?) -> CardIcon
    @ViewBuilder var header: Header
    var footer: Footer?

    private let cardHeight: CGFloat = 200

    
    @State private var showToolbar: (Bool, CGFloat) = (false,0)
    
    func dismissDetail() {
        withAnimation(.easeIn(duration: 0.35)){
            selected = nil
            showToolbar = (false, 0)
        }
    }
    
#warning("Fix color for macOS")

    public var body: some View {
        NavigationStack {
            Group {
                if let selected {
                    DestinationView(
                        card: selected,
                        cardHeight: cardHeight,
                        animation: animation,
                        showToolbar: $showToolbar,
                        dismiss: dismissDetail
                    ) { card in
                        cardView(card)
                    } cardDetails: { card in
                        cardDetail(card)
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done"){
                                dismissDetail()
                            }
                                .fontWeight(.semibold)
//                                .foregroundStyle(card.evm.color)
                        }
                        ToolbarItem(placement: .principal) {
                            cardIcon(selected)
                            .frame(width: 40, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .opacity(showToolbar.0 ? 1 : 0)
                            .offset(y: showToolbar.1)
                            .transition(.move(edge: .bottom))
                        }
                        
                    }
                } else {
                    VStack(spacing: 0){
                        CardStack(
                            animation: animation,
                            cards: cards,
                            additional: additional,
                            height: cardHeight,
                            currentCard: $selected,
                            header: header,
                            footer: footer
                        ) { card in
                            cardView(card)
                        }
                    }
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal){
                            Text(" ")
                        }
                    }
                    #endif
                }
            }
        }
    }
    

    
    

}

public extension CardList {
    init(
        animation: Namespace.ID,
        cards: [C],
        additional: [C] = [],
        selected: Binding<C?>,
        header: Header, 
        footer: Footer,
        @ViewBuilder cardView: @escaping (C) -> CardView,
        @ViewBuilder cardDetail: @escaping (C) -> CardDetails,
        @ViewBuilder cardIcon: @escaping (C?) -> CardIcon) 
    {
        self.cards = cards
        self._selected = selected
        self.animation = animation
        self.cardView = cardView
        self.cardDetail = cardDetail
        self.cardIcon = cardIcon
        self.header = header
        self.footer = footer
        self.additional = additional
    }
    
    init(
        animation: Namespace.ID,
        cards: [C],
        additional: [C] = [],
        selected: Binding<C?>,
        header: Header,
        @ViewBuilder cardView: @escaping (C) -> CardView,
        @ViewBuilder cardDetail: @escaping (C) -> CardDetails,
        @ViewBuilder cardIcon: @escaping (C?) -> CardIcon) where Footer == EmptyView
    {
        self.cards = cards
        self._selected = selected
        self.animation = animation
        self.cardView = cardView
        self.cardDetail = cardDetail
        self.cardIcon = cardIcon
        self.header = header
        self.additional = additional
        self.footer = nil
    }
}


//
//#Preview {
//    CardListView(cards: Card.cards) { card in
//        CardView(card: card)
//    }
//}
