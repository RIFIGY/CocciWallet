//
//  Button+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI

extension Button where Label == Image {
    init(systemName: String, action: @escaping () -> Void) {
        self.init(action: action) {
            Image(systemName: systemName)
        }
    }
}

struct ButtonCorner<T:View>: View {
    let action: () -> Void
    var color: Color = .blue
    var foreground: Color = .white
    var padding: CGFloat?
    var size: CGFloat = 15

    @ViewBuilder
    var content: T
    
    var body: some View {
        Button(action: action) {
            RoundedView(color: color, foreground: foreground, size: size, padding: padding) {
                content
            }
        }
    }
}


struct RoundedView<T:View>: View {
    let color: Color
    var foreground: Color = .white
    var size: CGFloat = 15
    var padding: CGFloat?
    
    @ViewBuilder
    var content: T
        
    var body: some View {
        content
        .frame(width: size, height: size)
          .padding()
          .foregroundColor(.white)
          .background(color)
          .cornerRadius(10)
    }
}
extension RoundedView {
    init(title: String, color: Color, foreground: Color = .white, size: CGFloat = 15, padding: CGFloat? = nil) where T == Text {
        self.content = Text(title)
        self.color = color
        self.foreground = foreground
        self.size = size
        self.padding = padding
    }
    
    init(systemImage: String, color: Color, foreground: Color = .white, size: CGFloat = 15, padding: CGFloat? = nil) where T == Image {
        self.content = Image(systemName: systemImage)
        self.color = color
        self.foreground = foreground
        self.size = size
        self.padding = padding
    }
}

extension ButtonCorner {
    init(title: String, color: Color, foreground: Color = .white, size: CGFloat = 15, padding: CGFloat? = nil, action: @escaping () -> Void) where T == Text {
        self.content = Text(title)
        self.color = color
        self.foreground = foreground
        self.size = size
        self.padding = padding
        self.action = action
    }
    
    init(systemImage: String, color: Color, foreground: Color = .white,size: CGFloat = 15,  padding: CGFloat? = nil, action: @escaping () -> Void) where T == Image {
        self.content = Image(systemName: systemImage)
        self.color = color
        self.foreground = foreground
        self.size = size
        self.padding = padding
        self.action = action
    }
}
