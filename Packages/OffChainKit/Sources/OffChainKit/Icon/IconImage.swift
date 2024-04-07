//
//  SwiftUIView.swift
//  
//
//  Created by Michael Wilkowski on 3/26/24.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif


public typealias IconView = IconImage
public struct IconImage: View {
    let symbol: String
    let color: Color
    let glyph: Color?
    let size: CGFloat?
    let hasImage: Bool

    public init(icon: Icon, size: CGFloat? = 32, glyph: Color? = nil) {
        self.symbol = icon.symbol
        self.color = icon.color
        self.glyph = glyph
        self.size = size
        self.hasImage = true
    }
    
    public init(symbol: String?, size: CGFloat? = 32, glyph: Color? = nil, fallback: Color = .indigo) {
        self.symbol = (symbol ?? "C").lowercased()
        self.glyph = glyph
        self.size = size
        if let symbol, let icon = Icon(symbol) {
            self.color = icon.color
            self.hasImage = true
        } else {
            self.color = fallback
            self.hasImage = false
        }
    }
    
    public init(symbol: String?, size: CGFloat? = 32, glyph: Color? = nil, override: Color) {
        self.symbol = (symbol ?? "C").lowercased()
        self.glyph = glyph
        self.size = size
        self.color = override
        if let symbol, Icon(symbol) != nil {
            self.hasImage = true
        } else {
            self.hasImage = false
        }
    }

    
    public var body: some View {
        if let size {
            content.frame(width: size, height: size)
        } else {
            content
        }
    }
    
    var systemName: String {
        guard let firstCharacter = symbol.lowercased().prefix(1).first else {
            return "c"
        }
        
        if firstCharacter.isNumber {
            return "\(firstCharacter)"
        } else if firstCharacter.isLetter {
            return "\(firstCharacter.lowercased())"
        } else {
            return "c"
        }
    }
    
    @ViewBuilder
    var image: some View {
        if hasImage {
            Image(symbol.lowercased(), bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: systemName+".circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)

        }
    }
    
    @ViewBuilder
    var content: some View {
        if let glyph {
            ZStack {
                glyph.padding(6).clipShape(.circle)
                image
                    .foregroundStyle(color)
            }
        } else {
            image
                .foregroundStyle(color)
        }
    }
    

}

#Preview {
    ZStack {
        Color.blue
        Image("matic", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .frame(width: 300, height: 300)
}

#Preview {
    IconImage(symbol: "ETH", fallback: .blue)
}

#Preview {
    IconImage(symbol: "E", fallback: .blue)
}

#Preview {
    IconImage(icon: .init(symbol: "eth", name: "Ethereum", hexColor: "#627eea"), glyph: .white)
}
