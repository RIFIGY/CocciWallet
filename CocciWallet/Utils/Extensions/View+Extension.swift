//
//  View+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    func conditional<Content:View, ElseContent: View>(
        _ condition: Bool,
        modifier: @escaping (Self) -> Content,
        not elseModifier: ((Self) -> ElseContent)? = nil
    ) -> some View {
        if condition {
            modifier(self)
        } else if let elseModifier {
            elseModifier(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func conditional<Content:View>(
        _ condition: Bool,
        modifier: @escaping (Self) -> Content
    ) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func optional<Item: Any, Content:View, ElseContent:View>(
        _ optional: Item?,
        modifier: @escaping (Self, Item) -> Content,
        else elseModifier: ((Self) -> ElseContent)? = nil
    ) -> some View {
        if let optional {
            modifier(self, optional)
        } else if let elseModifier {
            elseModifier(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func optional<Item: Any, Content:View>(
        _ optional: Item?,
        modifier: @escaping (Self, Item) -> Content
    ) -> some View {
        if let optional {
            modifier(self, optional)
        } else {
            self
        }
    }
    
    func cellBackground( padding: CGFloat? = nil, cornerRadius: CGFloat? = nil) -> some View {
        self.modifier( CellBackgroundModifier(padding: padding, cornerRadius: cornerRadius) )
        
    }
}

struct CellBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let padding: CGFloat?
    let cornerRadius: CGFloat?

    func body(content: Content) -> some View {
        content
        .optional(padding) { view, padding in
            view.padding(padding)
        }
        .conditional(colorScheme == .light) { view in
            view.background(Color.white)
        } not: { view in
            view.background(.regularMaterial)
        }
        .optional(cornerRadius){ view, radius in
            view.clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}

#if os(iOS)
extension View {
    public func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif

public struct UShapedBorder: Shape {
    public var radius: CGFloat
    public var lineWidth: CGFloat

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        
        // Start at the top left
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Draw down to the bottom left, starting the arc just before the corner to curve outwards
        path.addLine(to: CGPoint(x: 0, y: height - radius))
        
        // Add bottom left arc
        path.addArc(center: CGPoint(x: radius, y: height - radius), radius: radius,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
        
        // Draw bottom line to just before the right arc
        path.addLine(to: CGPoint(x: width - radius, y: height))
        
        // Add bottom right arc
        path.addArc(center: CGPoint(x: width - radius, y: height - radius), radius: radius,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 0), clockwise: true)
        
        // Draw up to the top right
        path.addLine(to: CGPoint(x: width, y: 0))
        
        return path.strokedPath(StrokeStyle(lineWidth: lineWidth))
    }
}

extension View {
    
    @ViewBuilder
    func targetable(cornerRadius: CGFloat = 16) -> some View {
        #if !os(macOS)
        self
        .contentShape(.hoverEffect, .rect(cornerRadius: 16))
        .hoverEffect()
        #else
        self
        #endif
    }
}

extension View {
    func systembackground() -> some View {
        self
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #else
        .background(.quaternary.opacity(0.5))
        #endif
    }
}
