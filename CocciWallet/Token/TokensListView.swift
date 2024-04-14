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
import WalletData
struct TokensListView<Transfer:ERCTransfer>: View {
    typealias Token = WalletData.Token
    @State private var showAddToken = false
    
    let network: Color
    let address: Web3Kit.EthereumAddress
    
    let balances: [Token]
    var transfers: [Transfer]
        
    var sortedBalances: [Token] {
        balances.sorted { $0.address < $1.address }
    }
    
    var contractInteractions: [Web3Kit.EthereumAddress] {
        Array(Set(transfers.map{$0.contract}))
    }
    
    var transferContracts: [Token] {
        let contracts = Array(Set(transfers.map { $0.contract }))
        let tokens = balances.filter{ contract in
            contracts.map{$0.string.lowercased()}.contains(contract.address.lowercased())
        }
        return tokens
    }
    
    @State private var selected: Token?
    
    var body: some View {
        List {
            ForEach(sortedBalances, id: \.address) { token in
                NavigationLink {
                    ERC20DetailView(token: token, transactions: transfers, network: network)
                } label : {
                    TokenCell(token, network: network)
                }
            }
            ERCTransactions(transfers: transferContracts, transactions: transfers, address: address, symbol: nil)
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
            ERC20DetailView(token: token, transactions: [ERC20Transfer](), network: network)
        }
    }
    
    func addToken(_ token: ContractEntity) async -> Bool {
        !contractInteractions.map{$0.string.lowercased()}.contains(token.address.lowercased())
    }
    
}



//#Preview {
//    TokensListView<Web3Kit.ERC20>(evm: .ETH, balances: [:], transfers: [:])
//        .environmentPreview(.rifigy)
//}

