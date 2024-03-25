//
//  NFTDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/4/24.
//

import SwiftUI

struct NFTDetailView: View {
    @Environment(\.theme) private var theme


    @Bindable var model: NftMetadata
    

    
    var additional: [String:Any]? {
        model.additional
    }
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            NFTImageView(url: model.imageUrl, image: model.image)
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.largeTitle.weight(.bold))
                Text(model.metadata?.description ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
                Section {
                    NavigationLink {
                        NftContractView(model.erc721)
                    } label: {
                        Text(model.erc721.contract)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                } header: {
                    Headline("Contract Address")
                }
                
                Section {
                    Text(model.tokenId.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Headline("Token ID")

                }
                if let additional = model.additional {
                    Section {
                        AdditionalNftDetails(details: additional)
                    } header: {
                        Headline("Addtitional")
                    }
                }
                if let attributes = model.metadata?.attributes {
                    Section {
                        NftAttributeGrid(attributes: attributes)
                    } header: {
                        Headline("Attributes")
                    }
                }
            }
            .padding(.horizontal)
        }
        .theme(theme)
    }
    
    func Headline(_ string: String) -> some View {
        Text(string)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top)
    }
}



#Preview {
    NavigationStack {
//        NFTDetailView(model: .init(nft: .munko2309Metadata))
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Text("Back")
//                }
//            }
    }
}
