//
//  SwiftUIView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//
//
//  WalletNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/12/24.
//

import SwiftUI


public struct CardList<Card:Identifiable & Equatable, CardView: View, Header: View, Footer:View, Destination:View, DestinationCard:View>: View where Card.ID == String {

    public let cardHeight: CGFloat
    
    @Binding public var selected: Card?
    @Binding public var cards: [Card]
    @Binding public var additional: [Card]
    
    @ViewBuilder
    public var cardView: (Card) -> CardView
    
    @ViewBuilder
    public var header: Header
    
    @ViewBuilder
    public var footer: Footer
    
    @ViewBuilder
    public var destination: (Card, AnyView) -> Destination
    
    public let destinationCard: (Card) -> DestinationCard
    
    @State private var draggedCard: Card?

    let animation: Namespace.ID


    public var body: some View {
        Group {
            CardScrollView(cardHeight: cardHeight, cards: cards, additional: additional) { card in
                cardView(card)
                    .onTapGesture {
                        withAnimation {
                            self.selected = card
                        }
                    }
                #if !os(tvOS)
                    .onDrag {
                        self.draggedCard = card
                        return NSItemProvider()
                    } preview: {
                        Color.white.opacity(0.001)
                    }
                    .onDrop(of: [.text],
                            delegate: DropViewDelegate(destinationItem: card, colors: $additional, draggedItem: $draggedCard)
                    )
                #endif
                    .matchedGeometryEffect(id: card.id + "_animation", in: animation)

            } header: {
                header
            } bottom: {
                footer
            }
        }
//        if let card = selected {
//            let destinationCard = AnyView(destinationCard(card).frame(height: cardHeight).matchedGeometryEffect(id: card.id + "_animation", in: animation))
//            destination(card, destinationCard)
//                
//        } else{
//            Group {
//                CardScrollView(cardHeight: cardHeight, cards: cards, additional: additional) { card in
//                    cardView(card)
//                        .onTapGesture {
//                            withAnimation {
//                                self.selected = card
//                            }
//                        }
//                    #if !os(tvOS)
//                        .onDrag {
//                            self.draggedColor = card
//                            return NSItemProvider()
//                        } preview: {
//                            Color.white.opacity(0.001)
//                        }
//                        .onDrop(of: [.text],
//                                delegate: DropViewDelegate(destinationItem: card, colors: $additional, draggedItem: $draggedColor)
//                        )
//                    #endif
//                        .matchedGeometryEffect(id: card.id + "_animation", in: animation)
//
//                } header: {
//                    header
//                } bottom: {
//                    footer
//                }
//            }
//
//        }

    }

}

#if !os(tvOS)
extension CardList {
    struct DropViewDelegate: DropDelegate {
        
        let destinationItem: Card
        @Binding var colors: [Card]
        @Binding var draggedItem: Card?
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }
        
        func performDrop(info: DropInfo) -> Bool {
            draggedItem = nil
            return true
        }
        
        func dropEntered(info: DropInfo) {
            // Swap Items
            if let draggedItem {
                let fromIndex = colors.firstIndex(of: draggedItem)
                if let fromIndex {
                    let toIndex = colors.firstIndex(of: destinationItem)
                    if let toIndex, fromIndex != toIndex {
                        withAnimation {
                            self.colors.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                        }
                    }
                }
            }
        }
    }
}
#endif


public extension CardList {
    typealias Dcard = (Card) -> DestinationCard
    init(
        height: CGFloat = 200,
        cards: Binding<[Card]>,
        additional: Binding<[Card]> = .constant([]),
        selected: Binding<Card?>,
        animation: Namespace.ID,
        @ViewBuilder cardView: @escaping (Card) -> CardView,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer,
        @ViewBuilder destination: @escaping (Card, AnyView) -> Destination,
        @ViewBuilder destinationCard: @escaping Dcard

    ) {
        self.cardHeight = height
        self._cards = cards
        self._additional = additional
        self._selected = selected
        self.cardView = cardView
        self.header = header()
        self.footer = footer()
        self.destination = destination
        self.destinationCard = destinationCard
        self.animation = animation

    }
    
    init(
        height: CGFloat = 200,
        cards: Binding<[Card]>,
        additional: Binding<[Card]> = .constant([]),
        selected: Binding<Card?>,
        animation: Namespace.ID,
        header: Header,
        footer: Footer,
        @ViewBuilder cardView: @escaping (Card) -> CardView,

        @ViewBuilder destination: @escaping (Card, AnyView) -> Destination

    ) where DestinationCard == CardView {
        self.cardHeight = height
        self._cards = cards
        self._additional = additional
        self._selected = selected
        self.cardView = cardView
        self.header = header
        self.footer = footer
        self.destination = destination
        self.destinationCard = cardView
        self.animation = animation

    }
}

//#Preview {
//    @State var cards: [Color] = {
//        var colors = [Color]()
//        for i in 0..<5 {
//            colors.append(.random)
//        }
//        return colors
//    }()
//    
//    @State var selected: Color?
//    
//    return CardList(cards: $cards, selected: $selected) { card in
//        CardView(color: card, header: card.id)
//    } header: {
//        Text("Header")
//            .font(.largeTitle)
//    } footer: {
//        Button("Button"){}.buttonStyle(.bordered)
//    } destination: { card in
//        CardView(color: card, header: card.id)
//    }
//
//}
