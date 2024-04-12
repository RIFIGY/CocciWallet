//
//  NetworkDetailView.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit

struct NetworkDetailView: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel
    
    let card: EthereumNetworkCard
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
    #endif
    
    @Namespace
    var animation
    
    var address: EthereumAddress { card.address }
    
    @State private var showSettings = false
    
    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    NetworkCardView(card: card, animation: animation)
                        .frame(height: 200)
                        .frame(maxWidth: 600)
                        .padding(.horizontal)
                    NetworkGrid(card: card)
                }
            }
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #else
        .background(.quaternary.opacity(0.5))
        #endif
        .background()
        .navigationTitle(card.name)
        .toolbar{
            ToolbarItem(placement: .automatic) {
                Button("Settings", systemImage: "gearshape") {
                    showSettings = true
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                NetworkCardSettings(card: card) {
                    
                }
            }
        }

//        .task {
//            await withTaskGroup(of: Void.self) { group in
//                for (contract, nfts) in self.card.nfts {
//                    for nft in nfts {
//                        group.addTask {
//                            let nftMetadata = NFTMetadata(nft: nft, contract: contract)
//                            await nftMetadata.fetch()
//                            self.metadata[contract, default: []].append(nftMetadata)
//                        }
//                    }
//                }
//            }
//        }
    }
    

}

struct NetworkGrid: View {
    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
    @Environment(PriceModel.self) private var priceModel

    let card: EthereumNetworkCard
    
    typealias Destination = NetworkCardDestination
    
    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                NetworkGridButton(.receive)
                NetworkGridButton(.send)
            }
            GridRow {
                VStack {
                    NetworkGridCell(.balance, balance: card.value, value: value)
                    NetworkGridCell(
                        .tokens,
                        balance: Double(card.tokens.keys.count),
                        value: tokenValue
                    )
                }
                NftGridCell(nfts: card.nfts, address: card.address, color: card.color)
            }
            GridRow {
                NetworkGridButton(.stake)
                NetworkGridButton(.swap)
            }
            DateTransactions(address: card.address.string, transactions: card.transactions)
        }
        .environment(card)
        .networkTheme(card: card)
        .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .fixedSize(horizontal: false, vertical: true)
        .padding([.horizontal, .bottom], 16)
        .frame(maxWidth: 1200)
        .navigationDestination(for: NetworkCardDestination.self) { destination in
            Group {
                switch destination {
                case .send:
                    Text("Send")
                case .receive:
                    AddressView(address: card.address.string, name: card.name)
                case .stake:
                    StakeView()
                case .swap:
                    SwapView()
                case .nft:
                    NFTGridView(nfts: card.nfts)
                case .tokens:
                    TokensListView(network: card.color, address: card.address, balances: card.tokens, transfers: [ERC20Transfer]())
                case .balance:
                    Text("Balance")
                }
            }
            #if !os(tvOS)
            .toolbarRole(.editor)
            #endif
        }
    }
        
    var price: Double? {
        priceModel.price(chain: card.chain, currency: currency)
    }
    
    var value: Double? {
        guard let balance = card.value, let price else {return nil}
        return balance * price
    }
    
    var tokenValue: Double {
        card.tokens.reduce(into: 0.0) { total, entry in
            let (contract, balance) = entry
            let price = priceModel.price(contract: contract.contract.string, currency: currency)
            let value = balance.value(decimals: contract.decimals) * (price ?? 0)
            total += value
        }
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

//
#Preview {
    NavigationStack {
        NetworkDetailView(card: .preview)
            .environmentPreview()
    }
}
