//
//  NFTDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/4/24.
//

import SwiftUI


struct NFTDetailView: View {
    @Environment(\.theme) private var theme
    @Environment(\.colorScheme) private var colorScheme
//    @Environment(Network.self) private var card

    let model: NFTEntity

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                NFTImageView(nft: model)
                    .frame(maxHeight: proxy.size.width)
                ScrollView(.vertical, showsIndicators: false){
                    Color.white
                        .frame(height: proxy.size.width)
                        .opacity(0.001)
                        .padding(.top, -16)
                    VStack(alignment: .leading) {
                        Text(model.name ?? "")
                            .font(.largeTitle.weight(.bold))
                            .padding(.top)
                        Text(model.metadata?.description ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 4)
                        Section {
                            NavigationLink {
//                                NftContractView(model: .init(contract: model.contract), address: model.contract, name: model.contractName, symbol: model.symbol)
//                                    .environment(card)
                            } label: {
                                AttributeCell(name: "") {
                                    Text(model.contract)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                            }
                        } header: {
                            Headline("Contract")
                        }
                        Section {
                            AttributeCell(name: "", value: model.tokenId.description)
                        } header: {
                            Headline("Token ID")
                        }
                        if !model.additional.isEmpty {
                            Section {
                                AdditionalNftDetails(details: model.additional)
                            } header: {
                                Headline("Addtitional")
                            }
                        }
                        if let attributes = model.opensea?.attributes {
                            Section {
                                NftAttributeGrid(attributes: attributes)
                            } header: {
                                Headline("Attributes")
                            }
                        }
                        HStack{Spacer()}
                    }
                    .padding(.horizontal)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    #if os(iOS)
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                    #endif
                }
                .theme(theme)
            }

        }
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
        NFTDetailView(model: .munko2309)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Text("Back")
                }
            }
    }
}
