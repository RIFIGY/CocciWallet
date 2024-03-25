////
////  WalletHolderView.swift
////  CocciWallet
////
////  Created by Michael Wilkowski on 3/17/24.
////
//
//import SwiftUI
//import CardSpacing
//
//
//struct WalletSelectionView: View {
//    @Environment(WalletHolder.self) private var manager
//    @Environment(NetworkManager.self) private var network
//    
//    let animation: Namespace.ID
//    
//    @State private var showNewWallet = false
//    
//    var body: some View {
//        VStack {
//            Header
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack(alignment: .bottom) {
//                    ForEach(self.manager.wallets) { wallet in
//                        WalletPouch(wallet)
//                    }
//                }
//                .scrollTargetLayout()
//            }
//            .scrollTargetBehavior(.paging)
//            Spacer()
//        }
//        .sheet(isPresented: $showNewWallet) {
//            AddWalletView { wallet in
//                self.manager.add(wallet: wallet)
//            }
//        }
//    }
//    
//    var Header: some View {
//        HStack {
//            Text("Wallets")
//                .font(.largeTitle).bold()
//            Spacer()
//            HeaderButton(systemName: "plus") {
//                showNewWallet = true
//            }
//            .padding(.trailing)
//        }
//        .padding().padding(.vertical)
//    }
//    
//    @ViewBuilder
//    func WalletPouch(_ wallet: WalletModel) -> some View {
//        let balances = wallet.cards.map { ($0.evm, $0.balance) }
//        WalletHolderView(
//            wallet: wallet,
//            totalBalance: network.value(balances: balances),
//            animation: animation
//        )
//        .frame(width: 350)
//        .onTapGesture {
//            withAnimation {
//                self.manager.selected = wallet
//            }
//        }
//    }
//}
//
//
//
//#Preview {
//    WalletSelectionView(animation: Namespace().wrappedValue)
//        .environment(WalletHolder(wallets: [.rifigy, .wallet]))
//}
