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
//    @Bindable var wallet: Wallet
    var address: Web3Kit.EthereumAddress
    @Binding var networks: [EthereumNetworkCard]
    @Binding var selection: EthereumNetworkCard?

    let settings: Wallet.Settings
    
    @State private var showNewNetwork: Bool = false
    
    var body: some View {
        List{
            ForEach($networks) { card in
//                NavigationLink {
//                    NetworkDetailView(card: card)
//                } label: {
                    NetworkCell(network: card)
                    .onTapGesture {
                        self.selection = card.wrappedValue
                    }
//                }
            }
            Button("Add"){
                self.showNewNetwork = true
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $showNewNetwork) {
            AddNetworkView(address: address) { network in
                guard !networks.map({$0.chain}).contains(network.chain) else {return}
                networks.append(network)
            }
        }
        
    }
}


import WalletData
struct NetworkCell: View {
//    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
//    @Environment(PriceModel.self) private var prices
    @Environment(NetworkManager.self) private var networks
    typealias Address = EthereumClient.Client.Account.Address

    @Binding var network: EthereumNetworkCard
    
    var compact: Bool = false
    var size: CGFloat = 42
        
    @State private var isUpdating = false
    
    var body: some View {
//        NavigationLink {
//            NetworkDetailView(card: $network)
//        } label: {
        Group {
            if compact {
                cell
            } else {
                banner
            }
        }
        .task {
            guard !isUpdating else {return}
            guard let ethClient = networks.getClient(chain: network.chain) else {return}
            let client = ethClient.node

            //        guard needsUpdate() else {print("Skipping \(name)");return false}
            //        print("Updating \(name)")

                    isUpdating = true
                await withTaskGroup(of: Void.self) { group in
                    let address = self.network.address
                    group.addTask {
                        let transactions = try? await Etherscan.shared.getTransactions(for: address.string, explorer: "etherscan.io")
                        Task { @MainActor in
                            network.transactions = transactions ?? []
                        }
                    }
                    
                    group.addTask {
                        Task { @MainActor in
                            network.balance = try? await client.fetchBalance(for: address)
                        }
                    }
                    group.addTask {
                        Task { @MainActor in
                            network.tokens = (try? await client.fetchTokens(for: address)) ?? [:]
                        }
                    }
                    group.addTask {
                        let nfts = (try? await ethClient.fetchNFTS(for: address)) ?? [:]
                        print("NFTS" + nfts.count.description)
                        Task{ @MainActor in
                            network.nfts = nfts
                        }
                    }
                }
                    isUpdating = false
                print("Balance:\(network.balance) TX: \(network.transactions.count) Tokens: \(network.tokens.keys.count) NFT: \(network.nfts.keys.count)")
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
                    Text(balance, format:.crypto(
                        decimals: network.decimals,
                        precision: 4
                    ))
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
