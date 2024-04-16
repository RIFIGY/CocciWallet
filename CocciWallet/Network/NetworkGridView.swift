//
//  NetworkGridView.swift
//  CocciWallet
//
//  Created by Michael on 4/15/24.
//

import SwiftUI
import Web3Kit
import SDWebImage
import SwiftData

struct NetworkGridView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel

    let card: Network
    
    typealias Destination = NetworkCardDestination
    
    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    NetworkGridButton(.receive)
                    NetworkGridButton(.send)
                }
                GridRow {
                    VStack {
                        NetworkGridCell(.balance, balance: card.balance, value: value)
                        NetworkGridCell(
                            .tokens,
                            balance: Double(card.tokens.count),
                            value: tokenValue
                        )
                    }
                    NavigationLink(value: Destination.nft) {
                        NftGridCell(nfts: card.nfts, address: card.address, color: card.color)
                    }
                }
                GridRow {
                    NetworkGridButton(.stake)
                    NetworkGridButton(.swap)
                }
                DateTransactions(address: card.address.string, transactions: card.transactions)

            }
            .networkTheme(card: card)
            .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .bottom], 16)
            .frame(maxWidth: 1200)
            .navigationDestination(for: NetworkCardDestination.self) { destination in
                Group {
                    switch destination {
                    case .send:
                        WalletSendView(network: card)
                    case .receive:
                        AddressView(address: card.address.string, name: card.name)
                    case .stake:
                        StakeView()
                    case .swap:
                        SwapView()
                    case .nft:
                        NFTGallery(nfts: card.nfts)
                    case .tokens:
                        TokensListView(
                            address: card.address,
                            balances: card.tokens,
                            transfers: [ERC20Transfer]()
                        )
                        .networkTheme(card: card)
                    case .balance:
                        Text("Balance")
                    }
                }
                #if !os(tvOS)
                .toolbarRole(.editor)
                #endif
            }
        }

    }
        
    var price: Double? {
        priceModel.price(chain: card.chain, currency: currency)
    }
    
    var value: Double? {
        guard let balance = card.balance, let price else {return nil}
        return balance * price
    }
    
    var tokenValue: Double {
        card.tokens.reduce(into: 0.0) { total, entry in
            let contract = entry
            let balance = contract.balance
            let price = priceModel.price(contract: contract.address, currency: currency)
            let value = (balance ?? 0) * (price ?? 0)
            total += value
        }
    }
}


struct NftGridCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Query private var stored: [NFT]
    
    let nfts: [NFT]
    let address: EthereumAddress
    
    //    let favorite: NftEntity?
    let color: Color
    var imageSize: CGFloat = 160
    
    private var cover: NFT? {
        nfts.first{$0.token.imageURL != nil}
    }
    
    
    @State private var cached = false
    @State private var showClaim = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NFT \(stored.count)")
            Group {
                if let cover {
                    NFTImageView(nft: cover.token, contentMode: .fill)
                        .cellBackground(padding: 8, cornerRadius: 16)
                    
                } else {
                    Button("Claim\nyour first \nNFT"){
                        self.showClaim = true
                    }
                    .foregroundStyle(color)
                    .font(.title.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .cellBackground(padding: 8, cornerRadius: 16)
                }
            }
            .frame(width: imageSize, height: imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
        .sheet(isPresented: $showClaim) {
            Text("Claim")
        }
        .onAppear(perform: preloadImages)
        
    }
    
    func preloadImages() {
        guard !cached else {return}
        let urls = nfts.compactMap{$0.token.gateway}
        let manager = SDWebImageManager.shared
        
        for url in urls {
            manager.loadImage(with: url, options: [.continueInBackground], progress: nil) { (image, data, error, cacheType, finished, imageURL) in
                if let img = image {
                    // Image is now cached by SDWebImage
                    print("Image preloaded: \(imageURL?.absoluteString ?? "URL not available")")
                } else if let err = error {
                    // Handle errors here
                    print("Error preloading image: \(err.localizedDescription)")
                }
            }
        }
        self.cached = true
    }
}
fileprivate struct NetworkGridButton: View {
    let destination: NetworkCardDestination
    init(_ destination: NetworkCardDestination) {
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(value: destination) {
            GridCell.Button(destination)
        }
    }
}

fileprivate struct NetworkGridCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"

    let destination: NetworkCardDestination
    
    let balance: Double?
    let value: Double?
    
    init(_ destination: NetworkCardDestination, balance: Double?, value: Double?) {
        self.destination = destination
        self.balance = balance
        self.value = value
    }
    
    var body: some View {
        NavigationLink(value: destination) {
            GridCell(title: destination.rawValue.capitalized, balance: balance, value: value, currency: currency)
        }
    }
}

#Preview {
    NetworkGridView(card: .preview)
}
