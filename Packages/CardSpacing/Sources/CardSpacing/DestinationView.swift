//
//  CardDetail.swift
//  CardList
//
//  Created by Michael Wilkowski on 3/22/24.
//

import SwiftUI

public struct DestinationView<C:Identifiable, CardView: View, CardDetails: View>: View {

    let card: C
    let cardHeight: CGFloat
    var animation: Namespace.ID
    
    @Binding var showToolbar: (Bool, CGFloat)

    let fadeDetails: Bool
    
    public init(card: C, cardHeight: CGFloat, animation: Namespace.ID, showToolbar: Binding<(Bool, CGFloat)>, fadeDetails: Bool = true, dismiss: @escaping () -> Void, @ViewBuilder cardView: @escaping (C) -> CardView, cardDetails: @escaping (C) -> CardDetails) {
        self.card = card
        self.cardHeight = cardHeight
        self.animation = animation
        self._showToolbar = showToolbar
        self.dismiss = dismiss
        self.cardView = cardView
        self.cardDetails = cardDetails
        self.fadeDetails = fadeDetails
    }

    var dismiss: () -> Void
    @ViewBuilder var cardView: (C) -> CardView
    @ViewBuilder var cardDetails: (C) -> CardDetails
    
    @State private var offset: CGPoint = .zero
    @State private var showExpenseView: Bool = false
    
    var systemGray: Color {
        #if canImport(UIKit)
        #if os(tvOS)
        return Color(uiColor: .systemGray)
        #else
        return Color(uiColor: .systemGray6)
        #endif
        #elseif canImport(AppKit)
        return Color(NSColor(white: 0.9, alpha: 1.0))
        #endif
    }

    public var body: some View{
        OffsetObservingScrollView(offset: $offset){
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let minY = geometry.bounds(of: .scrollView)?.minY

                    cardView(card)
                        .offset(y: offset.y <= 0 ? (minY ?? 0) : 0 )
                        .frame(height: cardHeight)
                        .matchedGeometryEffect(id: card.id, in: animation)
                        .padding(.horizontal)
                        .zIndex(10)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            if fadeDetails {
                                withAnimation {
                                    showExpenseView = false
                                }
                            }
                            dismiss()
                        }

                }
                .frame(height: cardHeight)
                cardDetails(card)
                    .padding()
                    .zIndex(-10)
                    .opacity(showExpenseView ? 1 : 0)
            }
            .padding(.bottom, 64)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .background(systemGray.ignoresSafeArea())
        .onAppear {
            if fadeDetails {
                withAnimation(.easeInOut(duration: 0.3).delay(0.3)){
                    showExpenseView = true
                }
            } else {
                showExpenseView = true
            }
        }
        .onChange(of: offset) { oldValue, newValue in
            setToolbar(offset: newValue.y)
        }
    }
    
    func setToolbar(offset: CGFloat) {
        let height: CGFloat = 20
        let base = cardHeight - height
        let normal = offset - base
        
        let show = (offset >= (cardHeight - height) )
        
        let minOffset = max(normal, -height/4)
        let maxOffset = height/4
        
        let offset = -min(minOffset, maxOffset)
        
        withAnimation {
            self.showToolbar = (show, offset)
        }
    }
}





//#Preview {
//    CardDetail(
//}
