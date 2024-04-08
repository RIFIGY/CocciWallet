//
//  NftListView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit
import ChainKit


struct NftListView<Client:ERC721Client>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(NetworkCard.self) private var card
    
    typealias NFT = Client.E721
    typealias NFTGroup = (NFT, [NFTMetadata])

    let model: NftVM<Client>
    
    var onTap: ((NFTMetadata) -> Void)? = nil
    
    
    @State private var isSectioned = false

    var sorted: [NFTGroup] {
        model.tokens.map { key, value in
            return (key,value)
        }
        .sorted{
            $0.1.count > $1.1.count
        }
    }
    
    var background: Color {
        colorScheme == .light ? Color.systemGray : .black
    }
    
    var collumnCount: Int = 2
    var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: collumnCount)
    }
    
    func name(_ contract: any Contract) -> String {
        contract.title
    }
    
    @ViewBuilder
    func Grid(for tokens: [NFTMetadata]) -> some View {
        LazyVGrid(columns: columns) {
            ForEach(tokens) { token in
                Cell(model: token, onTap: onTap)
            }
        }
    }
    
    struct SectionGrid: View {
        let name: String
        let tokens: [NFTMetadata]
        let columns: [GridItem]
        var onTap: ((NFTMetadata) -> Void)?
        
        @State private var isExpanded = true
        
        var body: some View {
            Section(isExpanded: $isExpanded) {
                LazyVGrid(columns: columns) {
                    ForEach(tokens) { token in
                        Cell(model: token, onTap: onTap)
                    }
                }
            } header: {
                HStack {
                    Text(name)
                    Spacer()
                    Button(systemName: isExpanded ? "chevron.down" : "chevron.right" ){
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
                }
                .font(.title3.weight(.semibold))
                .padding(.horizontal)
            }

        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isSectioned {
                ForEach(sorted, id: \.0.id) { contract, tokens in
                    SectionGrid(name: name(contract), tokens: tokens, columns: columns, onTap: onTap)
                }
            } else {
                LazyVGrid(columns: columns) {
                    ForEach(sorted, id: \.0.id) { contract, tokens in
                        Cell(model: tokens.first, title: name(contract), onTap: onTap) {
                            ScrollView{
                                Grid(for: tokens)
                            }
                            .navigationTitle(name(contract))
                            .background(background)
                        }
                    }
                }
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
        .environment(card)

    }

}


extension NftListView {
    
    struct Cell<D:View>: View {
        @Environment(NetworkCard.self) private var card

        let model: NFTMetadata
        var title: String?
        var size: CGFloat = 175
        
        var destination: D?
        var onTap: (NFTMetadata) -> Void = { _ in }
        
        var body: some View {
            if let destination {
                NavigationLink {
                    destination
                    .environment(card)
                    #if !os(tvOS)
                    .toolbarRole(.editor)
                    #endif
                } label: {
                    label
                }
                .foregroundStyle(.primary)
            } else {
                label
                .onTapGesture {
                    onTap(model)
                }
            }
        }
        
        var label: some View {
            VStack(spacing: 0) {
                if let title {
                    Text(title)
                        .font(.title3.weight(.semibold))
//                        .font(.headline)
                }
                NFTImageView(nft: model, contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                if title == nil {
                    Text("#" + model.tokenId.description)
                        .font(.headline)
                }
            }
        }
    }
}

extension NftListView.Cell {
    
    init?(model: NFTMetadata?, title: String? = nil, onTap: ((NFTMetadata)->Void)? = nil, @ViewBuilder destination: () -> D) {
        guard let model else {return nil}
        self.model = model
        if let onTap {
            self.onTap = onTap
        } else {
            self.destination = destination()
        }
        self.title = title
    }
    
    init?(model: NFTMetadata?, title: String? = nil, onTap: ((NFTMetadata)->Void)? = nil ) where D == NFTDetailView {
        guard let model else {return nil}
        self.model = model
        self.title = title
        if let onTap {
            self.onTap = onTap
        } else {
            self.destination = NFTDetailView(model: model)
        }
    }
}


#Preview {
    NavigationStack {
        NftListView(model: .preview)
//        NftListView(tokens: [ .Munko : [.munko] ])
    }
}
