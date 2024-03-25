//
//  NftAttributeGrid.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI
import Web3Kit

typealias Attribute = OpenSeaMetadata.Attribute
struct NftAttributeGrid: View {
    let attributes: [Attribute]

    
    var intGrid: [GridItem] {
        Array(repeating: .init(.flexible()), count: 3)
    }
    
    var doubleGrid: [GridItem] {
        Array(repeating: .init(.flexible()), count: 3)
    }
    
    var stringGrid: [GridItem] {
        Array(repeating: .init(.flexible()), count: 3)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if !stringAttributes.isEmpty {
                
                Section {
                    AttributeGrid(stringAttributes)
                } header: {
                    Text("Properties")
                        .font(.caption)
                        .padding(.top, 8)
                    
                }
            }
            if !intAttributes.isEmpty {
                Section {
                    AttributeGrid(intAttributes)
                } header: {
                    Text("Values")
                        .font(.caption)
                        .padding(.top)
                }
            }
            
            if !doubleAttributes.isEmpty {
                Section {
                    AttributeGrid(doubleAttributes)
                } header: {
                    Text("Values")
                        .font(.caption)
                        .padding(.top)
                }
            }
        }
    }
    
    struct Cell: View {
        let type: String
        let value: String
        
        var body: some View {
            VStack{
                Text(type)
                    .foregroundStyle(.secondary)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.9)
                Text(value)
                    .font(.title3.weight(.bold))
            }
            .padding(.horizontal, 2)
            .frame(width: 100, height: 70)
            .background(.regularMaterial )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    
    var stringAttributes: [Attribute] {
         attributes.filter {
             if case .string(_) = $0.value {
                 return true
             }
             return false
         }
    }
     
    var intAttributes: [Attribute] {
         attributes.filter {
             if case .int(_) = $0.value {
                 return true
             }
             return false
         }
    }
     
    var doubleAttributes: [Attribute] {
         attributes.filter {
             if case .double(_) = $0.value {
                 return true
             }
             return false
         }
    }
}

struct AttributeGrid<C:View>: View {
    
    let items: [(String, Any)]
    var collumns: Int = 3
    var cell: ((String, Any) -> C)? = nil
    
    private var gridCollumns: [GridItem] {
        .init(repeating: .init(.flexible()), count: collumns)
    }
    
    var body: some View {
        LazyVGrid(columns: gridCollumns) {
            ForEach(items, id: \.0) { item in
                if let cell {
                    cell(item.0,item.1)
                } else {
                    Cell(name: item.0, value: (item.1 as? String) ?? "")
                }
            }
        }
    }
    
    struct Cell<V:View>: View {
        let name: String
        var size: CGSize?
        
        @ViewBuilder
        var value: V
        
        var body: some View {
            VStack{
                Text(name)
                    .foregroundStyle(.secondary)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.9)
                value
                    .font(.title3.weight(.bold))
            }
            .padding(.horizontal, 2)
            .optional(size) { view, size in
                view.frame(width: size.width, height: size.height)
            }
            .background(.regularMaterial )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
}
extension AttributeGrid.Cell {
    init(name: String, value: String, size: CGSize? = .init(width: 100, height: 70)) where V == Text {
        self.name = name
        self.size = size
        self.value = Text(value)
    }
}

extension AttributeGrid {

    init(_ items: [Attribute], collumns: Int = 3,
        @ViewBuilder cell: @escaping (String, Any) -> C
    ) {
        self.collumns = collumns
        self.items = items.map{ ($0.traitType, $0.asString) }
        self.cell = cell
    }
    
    init(items: [(String,String)], collumns: Int = 3) where C == EmptyView {
        self.collumns = collumns
        self.items = items
        self.cell = nil
    }
    
    init(_ items: [Attribute], collumns: Int = 3) where C == EmptyView {
        self.collumns = collumns
        self.items = items.map{ ($0.traitType, $0.asString) }
        self.cell = nil
    }
}


//#Preview {
//    NftAttributeGrid(attributes: ERC721.Token.munko2309.opensea?.attributes ?? [])
//}
