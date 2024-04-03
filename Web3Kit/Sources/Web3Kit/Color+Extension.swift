
import SwiftUI

extension Color {
    
    static var systemGray: Color {
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
    
}
