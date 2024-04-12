////
////  WalletNetworkView.swift
////  CocciWallet
////
////  Created by Michael Wilkowski on 3/12/24.
////
//
//import SwiftUI
//import WalletData
//import OffChainKit
//
//struct WalletView: View {
//    @Environment(NetworkManager.self) private var network
//    @Environment(PriceModel.self) private var priceModel
//    @Environment(Navigation.self) private var navigation
//    
//    @AppStorage(AppStorageKeys.selectedCurrency) var currency: String = "usd"
//
//    @Bindable var wallet: Wallet
//
//    @Namespace private var animation
//
//    var body: some View {
//        let navigation = Bindable(navigation)
//        Group {
//            #if os(iOS)
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                cardList
//            } else {
//                if wallet.settings.displayAsCards {
//                    NetworkCardStack(
//                        name: wallet.name,
//                        networks: $wallet.networks,
//                        animation: animation
//                    ) { card in
//                        await update(card: card)
//                    }
//                } else {
//                    cardList
//                }
//            }
//            #else
//            cardList
//            #endif
//        }
//        .sheet(isPresented: navigation.showNewNetwork) {
//            AddNetworkView(address: wallet.address) { network in
//                if !wallet.networks.map({$0.id}).contains(network.id) {
//                    wallet.networks.append(network)
//                }
//            }
//        }
////        .navigationDestination(isPresented: $navigation.showWallets) {
////            NavigationStack {
////                SelectWalletView()
////            }
////                .presentationDetents([.medium, .large])
////        }
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Button("Wallets") {
//                    self.navigation.showWallets = true
//                }
//            }
//        }
//        #if os(iOS)
//        .navigationBarTitleDisplayMode(.inline)
//        #endif
//    }
//            
//    var cardList: some View {
//        NetworkList(
//            networks: wallet.networks,
//            selected: $wallet.selected,
//            settings: wallet.settings){ card in
//                await update(card: card)
//            }
//    }
//    
//
//    
//    private func update(card: EthereumNetworkCard) async {
//        
//        guard let client = network.getClient(chain: card.chain) else {return}
//        let updated: Bool = await card.update(with: client.node)
//        await card.fetchTransactions()
//
//        if updated {
//            await fetchPrice(for: card)
//        }
//    }
//    
//    private func fetchPrice(for card: EthereumNetworkCard) async {
//        guard let platform = CoinGecko.AssetPlatform.PlatformID(chainID: card.chain) else {return}
//        let contracts = card.tokens.map{$0.key.contract.string}
//        await priceModel.fetchPrices(contracts: contracts, platform: platform, currency: currency)
//    }
//}
//
//
//
////
////#Preview {
////    let preview = Preview()
////    return WalletView(wallet: .rifigy, showSettings: .constant(false), showWallets: .constant(false))
////        .environmentPreview()
////}
////
