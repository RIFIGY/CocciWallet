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
    
    @Environment(\.modelContext) private var context
    @Environment(Prices.self) private var prices
        
    let networks: [Network]
    
    @Binding var showNewNetwork: Bool
    
    var body: some View {
        List{
            ForEach(networks) { card in
                NavigationLink {
                    NetworkDetailView(card: card)
                } label: {
                    NetworkCell(network: card)
                }
            }
            Button("Add"){
                self.showNewNetwork = true
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            prices.fetch(coinIDs: coinIds, currency: currency)
        }
        .task {
            await updateCards()
        }
//        .task {
//            await
//        }
    }
    
    func updateCards() async {
        await withTaskGroup(of: Void.self) { group in
            networks.forEach { network in
                group.addTask { @MainActor in
                    guard network.needsUpdate() else {return}
                    do {
                        try await network.update(context: context)
                    } catch {
                        print(error)
                    }
                    await prices.fetchPrices(chain: network.chain, contracts: network.tokens.map{$0.contract.address}, currency: currency)

                }
            }
        }
        

    }

}

struct NetworkCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @Environment(NetworkManager.self) private var networks
    @Environment(Prices.self) private var prices
    enum CellType { case banner, cell, card }
    
    let network: Network
        
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
