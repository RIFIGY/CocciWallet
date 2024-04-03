//
//  AttributeGrid.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/1/24.
//

import SwiftUI
import Web3Kit

struct AttributeGrid<C:View,T:Any>: View {
    
    let items: [(String, T)]
    var columns: Int = 3
    
    @ViewBuilder
    var cell: (String, T) -> C
    
    private var gridCollumns: [GridItem] {
        .init(repeating: .init(.flexible()), count: columns)
    }
    
    var body: some View {
        LazyVGrid(columns: gridCollumns) {
            ForEach(items, id: \.0) { name, value in
                cell(name,value)
            }
        }
    }
}



extension AttributeGrid {
    
    init(
        _ items: [Attribute], columns: Int = 3,
        @ViewBuilder cell: @escaping (String, OpenSeaMetadata.AttributeValue) -> C
    ) where T == OpenSeaMetadata.AttributeValue {
        self.columns = columns
        self.items = items.map{ ($0.traitType, $0.value) }
        self.cell = cell
    }
    
    
    init(_ items: [Attribute], columns: Int = 3) where C == AttributeCell<Text>, T == OpenSeaMetadata.AttributeValue {
        self.columns = columns
        self.items = items.map{ ($0.traitType, $0.value) }
        self.cell = { name, value in
            AttributeCell(name: name, attribute: value)
        }
    }
    
    init(strings: [(String,String)], columns: Int = 3) where C == AttributeCell<Text>, T == String {
        self.columns = columns
        self.items = strings
        self.cell = { name, value in
            AttributeCell(name: name, string: value)
        }
    }
}


struct AttributeCell<V:View>: View {
    let name: String
    var width: CGFloat?
    var height: CGFloat?
        
    @ViewBuilder
    var value: V
    
    var body: some View {
        VStack{
            if !name.isEmpty {
                Text(name)
                    .foregroundStyle(.secondary)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            value
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(minWidth: 60, minHeight: 50)
        
        .padding(4)
        .optional(height) { view, height in
            view.frame(height: height)
        }
        .optional(width) { view, width in
            view.frame(width: width)
        }
        .frame(maxWidth: 80, maxHeight: 65)
        .background(.regularMaterial )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


extension AttributeCell {
    init(name: String, value: Any, size: CGSize? = nil) where V == Text {
        self.init(name: name, string: value as? String ?? "", size: size)
    }
    
    init(name: String, string: String, size: CGSize? = nil) where V == Text {
        self.name = name
        self.height = size?.height
        self.width = size?.width
        self.value = Text(string)
    }
    
    init(name: String, attribute: OpenSeaMetadata.AttributeValue, size: CGSize? = nil) where V == Text {
        self.name = name
        self.height = size?.height
        self.width = size?.width
        switch attribute  {
            case .string(let string):
                self.value = Text(string)
            case .int(let int):
                self.value = Text(int, format: .number)
            case .double(let double):
                self.value = Text(double, format: .number.precision(.fractionLength(2)))
            }
    }
}



#Preview("Grid") {
    AttributeGrid(NFTMetadata.munko2309.metadata!.attributes!, columns: 4)
}

#Preview("Cell"){
    AttributeCell(name: "Name", value: "Value")
}
