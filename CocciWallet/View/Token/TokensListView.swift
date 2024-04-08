//
//  ERC20View.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI
import BigInt
import Web3Kit
import ChainKit

struct TokensListView<Client:ERC20Client>: View {

    typealias Contract = Client.E
    typealias ERC20Transfer = Client.T
    @State private var showAddToken = false
    
    let model: TokenVM<Client>
    let network: Color
    let chain: Int
    
    var balances: [Contract: BigUInt] { model.balances }
    var transfers: [Contract : [ERC20Transfer] ] { model.transfers }
        
    var sortedBalances: [(contract: Contract, balance: BigUInt)] {
        balances.map {
            ($0.key, $0.value)
        }.sorted { $0.contract.contract.string < $1.contract.contract.string }
    }
    
    @State private var selected: Contract?
    
    var body: some View {
        List {
            ForEach(sortedBalances, id: \.contract.id) { token in
                ERC20TokenCell(token.contract, balance: token.balance, chain: chain, network: network)
                    .onTapGesture {
                        selected = token.0
                    }
            }
            ERCTransactions(transfers: Array(transfers.keys), transactions: transfers.flatMap{$0.value}, address: model.address, symbol: nil)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddToken = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }

//        #if !os(tvOS)
//        .toolbarRole(.editor)
//        #endif
        .sheet(isPresented: $showAddToken) {
            SearchERC20View(chain: chain, chosen: addToken)
        }
        .navigationDestination(item: $selected) { token in
            ERC20DetailView(token, balance: balances[token], tx: transfers[token] ?? [], network: network, chain: chain)
        }
    }
    
    func addToken(_ token: any ChainKit.Contract) async -> Bool {
        !model.contractInteractions.map{$0.lowercased()}.contains(token.contract.string.lowercased())
    }
    
}



//#Preview {
//    TokensListView<Web3Kit.ERC20>(evm: .ETH, balances: [:], transfers: [:])
//        .environmentPreview(.rifigy)
//}

