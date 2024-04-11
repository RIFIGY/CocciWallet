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

struct TokensListView<Token: Contract, Transfer:ERCTransfer>: View {

    @State private var showAddToken = false
    
    let network: Color
    let address: Web3Kit.EthereumAddress
    
    let balances: [Token : BigUInt]
    var transfers: [Transfer]
        
    var sortedBalances: [(contract: Token, balance: BigUInt)] {
        balances.map {
            ($0.key, $0.value)
        }.sorted { $0.contract.contract.string < $1.contract.contract.string }
    }
    
    var contractInteractions: [Web3Kit.EthereumAddress] {
        Array(Set(transfers.map{$0.contract}))
    }
    
    @State private var selected: Token?
    
    var body: some View {
        List {
            ForEach(sortedBalances, id: \.contract.id) { token in
                TokenCell(token.contract, balance: token.balance, network: network)
                    .onTapGesture {
                        selected = token.0
                    }
            }
//            ERCTransactions(transfers: Array(Set(transfers.map{$0.contract})), transactions: transfers, address: address, symbol: nil)
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
            SearchERC20View(chosen: addToken)
        }
        .navigationDestination(item: $selected) { token in
            ERC20DetailView(token, balance: balances[token], tx: [ERC20Transfer](), network: network)
        }
    }
    
    func addToken(_ token: any ChainKit.Contract) async -> Bool {
        !contractInteractions.map{$0.string.lowercased()}.contains(token.contract.string.lowercased())
    }
    
}



//#Preview {
//    TokensListView<Web3Kit.ERC20>(evm: .ETH, balances: [:], transfers: [:])
//        .environmentPreview(.rifigy)
//}
