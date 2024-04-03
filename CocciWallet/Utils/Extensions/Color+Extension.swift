//
//  Color+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 1/22/24.
//

import SwiftUI

//
//#if os(iOS)
//import UIKit
//#elseif os(watchOS)
//import WatchKit
//#elseif os(macOS)
//import AppKit
//#endif

#if canImport(UIKit)
import UIKit
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias PlatformColor = NSColor
#endif

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

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


public extension Color {
    static let ETH = Color(hex: "#627eea")!
}


