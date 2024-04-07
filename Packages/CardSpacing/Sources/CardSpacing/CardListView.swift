//
//  CardListView.swift
//  CardList
//
//  Created by Michael Wilkowski on 3/22/24.
//

import SwiftUI

public struct CardListView<C:Identifiable, CardView: View, CardDetails: View, CardIcon: View, Header: View, Footer: View>: View {
    
    let cards: [C]
    let additional: [C]
    @Binding var showDetail: Bool
    let animation: Namespace.ID

    @ViewBuilder var cardView: (C) -> CardView
    @ViewBuilder var cardDetail: (C) -> CardDetails
    @ViewBuilder var cardIcon: (C?) -> CardIcon
    @ViewBuilder var header: Header
    @ViewBuilder var footer: Footer

    private let cardHeight: CGFloat = 200

    
    @State private var selected: C?
    @State private var showToolbar: (Bool, CGFloat) = (false,0)
    
    
#warning("Fix color for macOS")

    public var body: some View {
        NavigationStack {
            Group {
                if let selected, showDetail {
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
                        CardStack(cards: cards, additional: additional, height: cardHeight, animation: animation, currentCard: $selected, showDetailCard: $showDetail) { card in
                            cardView(card)
                        } header: {
                            header
                        } footer: {
                            footer
                        }
                    }
    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
    #endif
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    //            .background(Color(uiColor: .systemGray6).ignoresSafeArea())
                    .toolbar {
                        ToolbarItem(placement: .principal){
                            Text(" ")
                        }
                    }
                }
            }
        }
    }
    

    
    
    func dismissDetail() {
        withAnimation(.easeIn(duration: 0.35)){
            showDetail = false
            selected = nil
            showToolbar = (false, 0)
        }
    }
}

public extension CardListView {
    init(
        cards: [C],
        additional: [C],
        showDetail: Binding<Bool>,
        animation: Namespace.ID,
        header: Header, footer: Footer,
        @ViewBuilder cardView: @escaping (C) -> CardView,
        @ViewBuilder cardDetail: @escaping (C) -> CardDetails,
        @ViewBuilder cardIcon: @escaping (C?) -> CardIcon) {
            
        self.cards = cards
        self._showDetail = showDetail
        self.animation = animation
        self.cardView = cardView
        self.cardDetail = cardDetail
        self.cardIcon = cardIcon
        self.header = header
        self.footer = footer
        self.additional = additional
    }
}

//
//#Preview {
//    CardListView(cards: Card.cards) { card in
//        CardView(card: card)
//    }
//}
