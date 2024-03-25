//
//  Icon.swift
//  CocciWallet
//
//  Created by Michael on 9/13/22.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

public struct Icon: Decodable, Identifiable, Equatable {
    public var id: String {self.symbol}
    public let symbol: String
    public let name: String
    public let color: String
        
    public var hexColor: Color? {
        return Color(hex: color)
    }
    
    var lowercased: String {
        symbol.lowercased()
    }

    
    init?(symbol: String?){
        if let symbol, let icon = Self.getIcon(for: symbol) {
            self = icon
        } else {
            return nil
        }
    }
    

    static fileprivate let all: [Icon] = {
        guard let bundlePath = Bundle.module.url(forResource: "icons", withExtension: "json") else {
            return []
        }
        if let data = try? Data(contentsOf: bundlePath),
           let icons = try? JSONDecoder().decode([Icon].self, from: data) {
            return icons
        } else {
            return []
        }
    }()
    
    public static func getIcon(for symbol: String?) -> Icon? {
        guard let symbol = symbol else {return nil}
        let icon = all.first(where: {$0.symbol.lowercased() == symbol.lowercased()})
        return icon
    }
    
    static let ETH: Icon = getIcon(for: "ETH")!
    
}

public enum IconType: String, CaseIterable {
    case black, white, color, icon
}

public struct IconView<P:View>: View {
    
    public let symbol: String
    public var type: IconType = .color
    
    public var size: CGFloat? = nil
    public let color: Color?
    var glyph = false
    
    @ViewBuilder
    let placeholder: P
    
    var icon: Icon? {
        .init(symbol: symbol)
    }
    
    var path: String? {
        guard let icon else {return nil}
        return icon.symbol.lowercased()
        //        return "\(type)/\(icon.symbol.lowercased())"
    }
    
    var foregroundColor: Color? {
        self.color ?? icon?.hexColor
    }
    
    
#if canImport(UIKit)
    var image: UIImage? {
        guard let path else {return nil}
        return UIImage(named: path, in: Bundle.module, compatibleWith: nil)
    }
#elseif canImport(AppKit)
    var image: PlatformImage? {
        guard let path, let pathURL = URL(string: path) else {return nil}
        return PlatformImage(contentsOf: pathURL)
    }
#endif
    
    
    func imageView(_ image: PlatformImage) -> some View {
        
#if canImport(UIKit)
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
#elseif canImport(AppKit)
        Image(path ?? "generic", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
#endif
    }
    
    @ViewBuilder
    var content: some View {
        if let foregroundColor {
            ZStack {
                if glyph {
                    Color.white.padding(6).clipShape(.circle)
//                    color.clipShape(Circle())
                }
                Group {
                    if let image {
                        imageView(image)
                    } else {
                        placeholder
                    }
                }
                .foregroundStyle(foregroundColor)
            }

        } else {
            if let image {
                imageView(image)
            } else {
                placeholder
            }
        }
    }
    
    public var body: some View {
        Group {
            if let size {
                content
                    .frame(width: size, height: size)
            } else {
                content
            }
        }

    }

    
}

#if os(iOS)
public extension IconView {
    init(symbol: String, _ type: IconType = .color, size: CGFloat? = nil, color: Color? = nil, glyph: Bool = false) where P == Image {
        self.symbol = symbol
        self.type = type
        self.size = size
        self.placeholder = Image(uiImage: UIImage(named: "generic", in: Bundle.module, compatibleWith: nil)!).resizable()
        self.color = color
        self.glyph = glyph
    }


}
#else
public extension IconView {
    init(symbol: String, _ type: IconType = .color, size: CGFloat? = nil, color: Color? = nil, glyph: Bool = false) where P == Image {
        self.symbol = symbol
        self.type = type
        self.size = size
        self.placeholder = Image("generic", bundle: .module).resizable()
        self.color = color
        self.glyph = glyph
    }


}
#endif
//    static fileprivate let all: [Icon] = {
//        guard let path = Bundle.main.path(forResource: "icons", ofType: "json") else {return []}
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let icons = try JSONDecoder().decode([Icon].self, from: data)
//            return icons
//        } catch {
//            return []
//        }
//    }()
    
    
//    var black: String {
//        "black/\(lowercased)"
//    }
//
//    var white: String {
//        "white/\(lowercased)"
//    }
//
//    var image: String {
//        "color/\(lowercased)"
//    }
//
//    var icon: String {
//        "icon/\(lowercased)"
//    }
//
