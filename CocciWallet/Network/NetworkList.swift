//
//  NetworkCardList.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/2/24.
//

import SwiftUI
import OffChainKit
import CardSpacing
import Web3Kit
import BigInt
import ChainKit
import SwiftData

struct NetworkList: View {
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCoins) private var coinIds = "ethereum"
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @Environment(NetworkManager.self) private var clients
    @Environment(Prices.self) private var prices
    let address: Web3Kit.EthereumAddress
    
    @Binding var networks: [EthereumNetworkCard]
//    @Binding var selection: EthereumNetworkCard?
    @Binding var showNewNetwork: Bool
    
    var body: some View {
        List{
            ForEach(networks) { card in
                NavigationLink {
                    NetworkDetailView(card: card)
                } label: {
                    NetworkCell(network: card)
                }
                    
//                    .onTapGesture {
//                        self.selection = card.wrappedValue
//                    }
            }
            Button("Add"){
                self.showNewNetwork = true
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            prices.fetch(coinIDs: coinIds, currency: currency)
            networks.forEach { network in
                Task {
                    await updateCard(network:network)
                }
            }
        }
        
    }
    
    private func updateCard(network: EthereumNetworkCard) async {
//        print("Updating")
//        guard let ethClient = clients.getClient(chain: network.chain) else {return}
//        let client = ethClient.node
//        let updated = await network.update(with: client) { address, explorer in
//            try await Etherscan.shared.getTransactions(for: address, explorer: explorer)
//        }
//        if updated {
//            await prices.fetchPrices(chain: network.chain, contracts: network.tokens.map{$0.contract}, currency: currency)
//            print(
//                network.name + " " +
//                network.address.string.suffix(6) +
//                "\n\tTransactions:\(network.transactions.count)" +
//                "\n\tBalance:\(network.balance?.formatted(.crypto(decimals: network.decimals)) ?? "nil")" +
//                "\n\tTokens:\(network.tokens.count)" +
//                "\n\tNFTs:\(network.nfts.count), \(network.nfts.flatMap{$0.value}.count)"
//            )
//        } else {
//            print("Skipped: \(network.name)")
//        }
    }
}


import WalletData
struct NetworkCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @Environment(NetworkManager.self) private var networks
    @Environment(Prices.self) private var prices
    enum CellType { case banner, cell, card }
    
    @Bindable var network: EthereumNetworkCard
    
    var type: CellType = .banner
    var size: CGFloat = 42
    var price: Double? {
        prices.price(chain: network.chain, contract: nil, currency: currency)
    }
    @State private var isUpdating = false
    
    var body: some View {
        Group {
            switch type {
            case .banner:
                banner
            case .cell:
                cell
            case .card:
                card
            }
        }
    }
    
    var banner: some View {
        HStack {
            IconView(symbol: network.symbol, size: size)
                .frame(height: 40)
            VStack(alignment: .leading){
                Text(network.name)
                Text(network.symbol)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                if let balance = network.balance {
                    Text(balance, format: .number)
                }
                if let price {
                    Text(price, format: .currency(code: currency))
                }
            }
        }
    }
    
    var cell: some View {
        IconCell(symbol: network.symbol, color: network.color) {
            Text(network.name)
        }
    }
    
    var card: some View {
        NetworkCardView(card: network)
    }
}

extension NetworkCell {
    

}
//#Preview {
//    NavigationStack {
//        NetworkList(address: .rifigy, networks: .constant([.preview]), settings: .init())
//            .environmentPreview()
//    }
//}
//
