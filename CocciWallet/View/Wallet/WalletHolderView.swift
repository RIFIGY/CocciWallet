//
//  WalletHolderView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import SwiftUI
import CardSpacing

struct WalletHolderView: View {
    let wallet: WalletModel
    let totalBalance: Double

    var cardHeight: CGFloat = 160
    var color: Color = .black
    let animation: Namespace.ID
    
    var cards: [NetworkCard] { Array(wallet.cards.prefix(5)) }

    
    let padding: CGFloat = 18
    
    @ViewBuilder
    var cardStack: some View {
        VStack(spacing: -cardHeight * 0.72){
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                CardView(color: card.color ?? .ETH) {
                    Text(card.name)
                }
                .frame(height: cardHeight)
//                .matchedGeometryEffect(id: card.id + "_animation", in: animation)//, isSource: true)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            cardStack
                .padding(.bottom, 32)
            WalletCover(
                cardHeight: cardHeight,
                padding: padding,
                color: color
            )
            titleOverlay
        }
        .padding(padding)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 2)
        )
        .padding(.horizontal)
    }
    
    var titleOverlay: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Image(systemName: wallet.type.systemImage)
                    .font(.title)
                    .foregroundStyle(wallet.type.color)
                Text(wallet.name)
                    .font(.title)
            }
            Spacer()
            Text(totalBalance, format: .currency(code: "USD"))
        }
        .padding()
        .padding(.horizontal)
        .foregroundStyle(.white)
    }

}


enum WalletKey: String, CaseIterable, Identifiable, Codable {

    case watch, privateKey, mnemonic
    var id: String { rawValue }
    var systemImage: String {
        switch self {
        case .watch:
            "magnifyingglass"
        case .privateKey:
            "key"
        case .mnemonic:
            "list.bullet.rectangle"
        }
    }

    var color: Color {
        switch self {
        case .watch:
            Color.blue
        case .privateKey:
            Color.purple
        case .mnemonic:
            Color.orange
        }
    }
}
struct WalletCover: View {
    let cardHeight: CGFloat
    let padding: CGFloat
    let color: Color
    var overlay: (Color, CGFloat) = (.gray, 2)
    
    var modifier: CGFloat { cardHeight * 0.30 }

    var body: some View {
        Shape()
            .fill(color)
            .frame(height: cardHeight - modifier/2)
            .overlay(
                Shape(padding: padding)
                    .stroke(.gray, lineWidth: 2)
            )
    }
    
    struct Shape: SwiftUI.Shape {
        var padding: CGFloat?
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let cutoutRadius = rect.width * 0.15
            let cutoutCenter = CGPoint(x: rect.midX, y: rect.minY)
            let startArcX = cutoutCenter.x - cutoutRadius
    //        let endArcX = cutoutCenter.x + cutoutRadius
            
            if let padding {
                path.move(to: CGPoint(x: rect.minX + padding, y: rect.minY))
                path.addLine(to: .init(x: startArcX, y: rect.minY))
                path.addArc(center: cutoutCenter, radius: cutoutRadius, startAngle: Angle(degrees: -180), endAngle: Angle(degrees: 0), clockwise: true)
                path.addLine(to: .init(x: rect.maxX - padding, y: rect.minY))
            } else {
                
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                
                path.move(to: CGPoint(x: cutoutCenter.x + cutoutRadius, y: cutoutCenter.y))
                path.addArc(center: cutoutCenter, radius: cutoutRadius, startAngle: Angle(degrees: -180), endAngle: Angle(degrees: 0), clockwise: true)
                
            }
            
            return path
        }
    }
}

import Web3Kit
#Preview {
    WalletHolderView(wallet: .init(.rifigy), totalBalance: 324.23, animation: Namespace().wrappedValue)
}
