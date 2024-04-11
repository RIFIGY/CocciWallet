//
//  NftAttributeGrid.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI
import Web3Kit


struct NftAttributeGrid: View {
    typealias Attribute = OpenSeaMetadata.Attribute

    let attributes: [Attribute]

    
    var body: some View {
        VStack(alignment: .leading) {
            if !attributes.strings.isEmpty {
                Section {
                    AttributeGrid(attributes.strings)
                } header: {
                    Text("Properties")
                        .font(.caption)
                        .padding(.top, 8)
                    
                }
            }
            if !attributes.ints.isEmpty {
                Section {
                    AttributeGrid(attributes.ints)
                } header: {
                    Text("Values")
                        .font(.caption)
                        .padding(.top)
                }
            }
            
            if !attributes.doubles.isEmpty {
                Section {
                    AttributeGrid(attributes.doubles)
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
}






//#Preview {
//    NftAttributeGrid(attributes: ERC721.Token.munko2309.opensea?.attributes ?? [])
//}
