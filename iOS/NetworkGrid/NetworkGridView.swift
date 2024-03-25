//
//  NetworkGridDetailView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit
import BigInt

struct NetworkGridView: View {
    @AppStorage("currency") var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel
    
    let model: NetworkCard
    var price: (Double, String)? {
        priceModel.price(evm: model.evm, currency: currency)
    }

    
    var body: some View {
        VStack(spacing: 16) {
            WalletActionView(evm: model.evm, address: model.address)
            HStack {
                VStack {
                    NativeBalanceGridCell(evm: model.evm, balance: model.balance)
                    TokensGridCell(evm: model.evm, tokenBalances: [:])
                }
                NftCell(tokens: model.tokens)
            }
        }
    }
}

fileprivate struct NftCell: View {
    @Environment(\.colorScheme) var colorScheme
    
    let tokens: [ERC721 : [NftMetadata]]
    var nfts: [NftMetadata] { tokens.flatMap{$0.value} }
    var nft: NftMetadata? {
        nfts.first{ $0.imageUrl != nil }
    }
    
    var background: Color {
        colorScheme == .light ? .white :.systemGray
    }
        
    @State private var showNFTs = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NFT")
            NFTImageView(url: nft?.imageUrl, image: nft?.image, isCell: true, placeholder: background)
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
//        .padding(.horizontal, 8)
        .cellBackground(padding: 8, cornerRadius: 16)
        .onTapGesture {
            self.showNFTs = true
        }
        .fullScreenCover(isPresented: $showNFTs) {
            NavigationStack {
                NftListView(tokens: tokens)
            }
        }
    }
}


struct NetworkGridCell: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let balance: Double?
    let value: Double?
    var currency: String? = "USD"

    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Text(balance?.string(decimals: 5) ?? "--")
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .font(.title.weight(.bold))
                if let value, let currency {
                    Text(value, format: .currency(code: currency))
                        .foregroundStyle(.secondary)
                }else{
                    Text("--")
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 8)
//        .padding(.vertical, 8)
        .cellBackground(padding: 8, cornerRadius: 16)

    }
}

import CardSpacing
#Preview {
    ScrollView(.vertical, showsIndicators: false) {
        VStack {
            CardView(color: .ETH, header: "Test").frame(height: 200)
            NetworkGridView(model: .ETH)
        }
        .padding(.horizontal)
    }
    .background(Color.systemGray)
    .environment(PriceModel.preview)
}
