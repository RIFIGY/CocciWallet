//
//  ERC20View.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI
import BigInt
import Web3Kit

struct ERC20View<T:Web3Kit.ERC20Protocol>: View {
    @Environment(NetworkManager.self) var networkManager
    
    @State private var showAddToken = false
    
    let evm: EVM
    
    let balances: [T: BigUInt]
    let transfers: [T : [ERC20Transfer] ]
    
    var transactions: [ERC20Transfer] {
        transfers.flatMap{$0.value}
    }
    
    var sortedBalances: [(contract: T, balance: BigUInt)] {
        balances.map {
            ($0.key, $0.value)
        }.sorted { $0.contract.id < $1.contract.id }
    }
    
    var body: some View {
            List {
//                Web3Kit.TestColor().frame(height: 100)
                ForEach(sortedBalances, id: \.contract.id) { token in
                    ERC20TokenCell(token.contract, balance: token.balance, evm: evm)
                    .background (
                        NavigationLink("", destination:
                        ERC20DetailView(
                            token.contract, balance: token.balance, tx: transfers[token.contract] ?? [] )
                        )
                    )
                }
                Section("Latest"){
                    ERCTransactions(model: .init(address: Wallet.rifigy.address, price: nil, evm: evm), transfers: transfers)
                }
            }
            .toolbar {
                #if os(macOS)
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddToken = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                    #else
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddToken = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                    #endif
            }
            #if !os(tvOS)
            .toolbarRole(.editor)
            #endif
            .sheet(isPresented: $showAddToken) {
                SearchERC20View(chosen: addToken)
            }
    }
    
    func addToken(_ token: any ERC20Protocol) async {
//        await model.add(token: contract, to: wallet)
    }
    
}



//#Preview {
//    ERC20View()
//        .environment(WalletViewModel.preview)
//}

