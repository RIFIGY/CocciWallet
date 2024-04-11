//
//  CellIcon.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/26/24.
//

import SwiftUI

typealias IconCell = CellIcon
struct CellIcon<I:View, C:View>: View {
    var label: String? = nil
    let color: Color
    var foreground: Color = .white
    var size: CGFloat = 32
    var imageSize: CGFloat { size / 1.5 }
    
    
    @ViewBuilder
    var icon: I
    
    @ViewBuilder
    var cell: C


    var iconView: some View {
        ZStack {
            color
            icon.aspectRatio(contentMode: .fit)
                .padding(size/5)
                .foregroundStyle(foreground)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var body: some View {
        if let _ = cell as? EmptyView {
            iconView
        } else {
            HStack {
                iconView
                    .padding(.vertical, 2)
                    .padding(.trailing, 2)
                if let label {
                    Text(label)
                }
                cell
            }
//            .listRowInsets(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 16))
        }

    }
}

extension CellIcon {
    init(label: String? = nil, systemImage: String, color: Color, foreground: Color = .white, size: CGFloat = 32, @ViewBuilder content: () -> C) where I == Image {
        self.init(label: label, color: color, foreground: foreground, size: size) {
            Image(systemName: systemImage).resizable()
        } cell: {
            content()
        }

    }
}

//extension CellIcon {
//    init(content: String, color: Color, foreground: Color = .white, size: CGFloat = 32, @ViewBuilder icon: () -> I) where C == Text{
//        self.init(color: color, foreground: foreground, size: size, icon: icon) {
//            Text(content)
//        }
//    }
//}

extension CellIcon where C == EmptyView {
    init(color: Color, foreground: Color = .white, size: CGFloat = 32, @ViewBuilder icon: () -> I){
        self.init(color: color, foreground: foreground, size: size, icon: icon) {
            EmptyView()
        }
    }
    
    init(systemImage: String, color: Color, foreground: Color = .white, size: CGFloat = 32) where I == Image {
        self.init(color: color, foreground: foreground, size: size){
            Image(systemName: systemImage).resizable()
        }
    }
    
    init(symbol: String, color: Color, foreground: Color = .white, size: CGFloat = 32) where I == IconView {
        self.init(color: color, foreground: foreground, size: size){
            IconView(symbol: symbol, glyph: .white)
        }
    }
}

extension CellIcon {
    
    init(systemImage: String, color: Color, foreground: Color = .white, size: CGFloat = 32, @ViewBuilder cell: () -> C) where I == Image {
        self.init(color: color, foreground: foreground, size: size) {
            Image(systemName: systemImage).resizable()
        } cell: {
            cell()
        }
    }
    
    init(symbol: String, color: Color, foreground: Color = .white, size: CGFloat = 32, @ViewBuilder cell: () -> C) where I == IconView {
        self.init(color: color, foreground: foreground, size: size) {
            IconView(symbol: symbol, glyph: .white)
        } cell: {
            cell()
        }
    }
}

import OffChainKit
#Preview {
    List {
        ForEach(1..<20) { i in
            let odd = i % 2 == 0
            if odd {
                CellIcon(systemImage: "gearshape", color: .teal) {
                    Text("Label \(i) testing")
                }
            } else {
                HStack {
                    CellIcon(color: .purple) {
                        IconView(symbol: "MATIC", glyph: .white)
                    }
                    Text("Label \(i) testing")
                }
            }
            
            
        }
    }
}
