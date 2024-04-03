//
//  TransactionSentView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/25/24.
//

import SwiftUI
import web3
import Web3Kit

fileprivate typealias Cell = TransactionInfoCell
struct TransactionSentView: View {
    @Environment(NetworkManager.self) private var network
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var model: SendViewModel
    let txHash: String
    
    @State var transaction: EthereumTransactionReceipt?
    @State private var showEtherscan = false
    
    var explorerURL: URL? {
        guard let explorer = model.evm.explorer else {return nil}
        return URL(string: "https://\(explorer)/tx/\(txHash)")
    }
    
    var body: some View {
        Form {
            Text(txHash)
            if let transaction, let log = transaction.logs.first{
                EthereumLogInfo(log: log)
            }
            if let explorerURL {
                WebLink(url: explorerURL)
            }
        }

            .task {
//                self.transaction = try? await network.getClient(model.evm).getReceipt(txHash: txHash)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(systemName: "xmark") {
                        model.done = true
                    }
                }
            }
    }
}


#Preview {
    TransactionSentView(model: .init(evm: .ETH, address: Wallet.rifigy.address, decimals: 18), txHash: Wallet.rifigy.address)
        .environment(NetworkManager())
}

