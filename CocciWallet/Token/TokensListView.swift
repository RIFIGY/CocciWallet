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

struct TokensListView<Transfer:ERCTransfer>: View {
    @Environment(\.networkTheme) private var theme
    @State private var showAddToken = false
    
    var network: Color { theme.color }
    let address: Web3Kit.EthereumAddress
    
    let balances: [Token]
    var transfers: [Transfer]
        
    var sortedBalances: [Token] {
        balances.sorted { $0.address < $1.address }
    }
    
    var transferContracts: [Token] {
        let contracts = Array(Set(transfers.map { $0.contract }))
        let tokens = balances.filter{ contract in
            contracts.map{$0.string.lowercased()}.contains(contract.address.lowercased())
        }
        return tokens
    }
        
    var body: some View {
        List {
            ForEach(sortedBalances) { token in
                NavigationLink {
                    ERC20DetailView(token: token, transactions: [Transfer]())
                } label : {
                    TokenCell(token)
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
    }
    
    func addToken(_ token: ContractEntity) async -> Bool {
        let contractInteractions = Array(Set(transfers.map{$0.contract}))
        return !contractInteractions.map{$0.string.lowercased()}.contains(token.address.lowercased())
    }
    
}



#Preview {
    let preview = Preview()

    return NavigationStack {
        TokensListView(address: .rifigy, balances: [.USDC], transfers: [ERC20Transfer]())
    }
        .environmentPreview()
}
