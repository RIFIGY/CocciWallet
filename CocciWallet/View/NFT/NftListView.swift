//
//  NftListView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit

struct NftListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    typealias NFTGroup = (ERC721, [NftMetadata])

    
    let tokens: [ERC721: [NftMetadata]]
    
    @State private var isSectioned = false

    var sorted: [NFTGroup] {
        tokens.map { key, value in
            return (key,value)
        }
        .sorted{
            $0.1.count > $1.1.count
        }
    }
    
    var background: Color {
        colorScheme == .light ? Color.systemGray : .black
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isSectioned {
                sectioned
            } else {
                grouped
            }
        }
        .background(background)
        #if !os(tvOS)
        .toolbarRole(.editor)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(systemName: "rectangle.3.group") {
                    withAnimation {
                        isSectioned.toggle()
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Define two columns

    
    @ViewBuilder
    var sectioned: some View {
        ForEach(sorted, id: \.0.id) { contract, tokens in
            Section {
                LazyVGrid(columns: columns) { // Use LazyVGrid to layout tokens
                    ForEach(tokens) { token in
                        Cell(model: token)
                    }
                }
                .padding(.horizontal)
            } header: {
                Text(contract.name ?? contract.contract.shortened() )
                    .font(.title2.weight(.bold))
            }

        }
    }
    
    var grouped: some View {
        LazyVGrid(columns: columns) { // Use LazyVGrid to layout tokens
            ForEach(sorted, id:\.0.id) { contract, tokens in
                if let first = tokens.first {
                    Cell(model: first, title: contract.name ?? " ") {
                        ScrollView{
                            LazyVGrid(columns: columns) { // Use LazyVGrid to layout tokens
                                ForEach(tokens) { token in
                                    Cell(model: token)
                                }
                            }
                        }
                        .navigationTitle(contract.name ?? contract.symbol ?? contract.contract.shortened())
                        .background(background)
                    }
                }
            }
        }
        .padding(.horizontal)

    }
    
    struct Cell<D:View>: View {
        let model: NftMetadata
        var title: String?
        var size: CGFloat = 175
        
        @ViewBuilder
        var destination: D
        
        var body: some View {
            NavigationLink {
                destination
                #if !os(tvOS)
                .toolbarRole(.editor)
                #endif
            } label: {
                VStack(spacing: 0) {
                    if let title {
                        Text(title)
                            .font(.headline)
                    }
                    NFTImageView(url: model.imageUrl, image: model.image, isCell: true)
                        .frame(width: size, height: size)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    if title == nil {
                        Text("#" + model.tokenId.description)
                            .font(.headline)
                    }
                }
            }
            .foregroundStyle(.primary)
        }
    }
}

extension NftListView.Cell {
    init(model: NftMetadata, size: CGFloat = 175) where D == NFTDetailView {
        self.model = model
        self.size = size
        self.destination = NFTDetailView(model: model)
    }
}

//#Preview {
//    NftListView()
//}
