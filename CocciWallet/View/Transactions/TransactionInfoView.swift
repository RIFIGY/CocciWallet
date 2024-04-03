//
//  TransactionInfoView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI
import Web3Kit
import OffChainKit

struct TransactionInfoView: View {
    
    let tx: any TransactionProtocol
    var symbol: String?
    
    var body: some View {
        List {
            VStack {
                HStack {
                    Text(tx.amount?.string(decimals: 4) ?? "")
                        .fontWeight(.bold)
                    if let symbol = symbol {
                        Text(symbol)
                            .font(.largeTitle)
                    }
                }
                    .font(.system(size: 64))
                Group {
                    Text(tx.title)
                    if let date = tx.date {
                        Text(date.formatted(date: .numeric, time: .standard))
                    }
                }
                .foregroundStyle(.secondary)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            Section {
                Cell(title: "From:", value: tx.fromAddressString)
                Cell(title: "To:", value: tx.toAddressString)
            } header: {
                HStack{
                    Text("Block Info")
                    Spacer()
                }
                .padding(.top)
            }
            ChainScanInfo(tx: tx)

        }
    }
    

}

struct ChainScanInfo: View {

    let tx: any TransactionProtocol
    var decimals: UInt8 = 18

    var body: some View {
        if let tx = tx as? Etherscan.Transaction {
            Group {
                Section {
                    Cell(title: "Block Number", value: tx.blockNumber)
                    Cell(title: "Time Stamp", value: tx.timeStamp)
                    Cell(title: "Hash", value: tx.hash)
                    Cell(title: "Nonce", value: tx.nonce)
                }
                Section {
                    Cell(title: "Block Hash", value: tx.blockHash, lineLimit: nil)
                    Cell(title: "Transaction Index", value: tx.transactionIndex)
                }
                Section {
                    Cell(title: "Gas", value: tx.gas)
                    Cell(title: "Gas Price", value: tx.gasPrice)
                    Cell(title: "Gase Used", value: tx.gasUsed)
                    Cell(title: "Cumulative Gas Used", value: tx.cumulativeGasUsed)
                    Cell(title: "Error", value: tx.isError)
                }
                
                Section {
                    Cell(title: "Receipt Status", value: tx.txreceiptStatus)
                    Cell(title: "Input", value: tx.input, lineLimit: nil)
                    Cell(title: "Contract Address", value: tx.contractAddress)
                }
                
                Section {
                    Cell(title: "Confirmations", value: tx.confirmations)
                    Cell(title: "Method ID", value: tx.methodID)
                    Cell(title: "Function Name", value: tx.functionName)
                }
            }
            #if !os(tvOS)
            .textCase(nil)
            #endif
        } else if let tx = tx as? any ERCTransfer {
            EthereumLogInfo(log: tx.log)
        }
    }

}


import web3
struct EthereumLogInfo: View {
    let log: EthereumLog
    
    var blockNumber: String {
        if let int = log.blockNumber.intValue {
            return "\(int.description) - \(log.blockNumber.stringValue)"
        } else {
            return log.blockNumber.stringValue
        }
    }
    
    var body: some View {
        Group {
//                if let tx = tx as? ERC721Transfer {
//
//                }
            Section {
                Cell(title: "Contract", value: log.address.asString())
                Cell(title: "Data", value: log.data, lineLimit: nil)
                Cell(title: "Removed", value: log.removed?.description)
            }
            Section {
                Cell(title: "Log Index", value: log.logIndex?.description)
                Cell(title: "Transaction Index", value: log.transactionIndex?.description)
                Cell(title: "Transaction Hash", value: log.transactionHash, lineLimit: nil)
            }
//
            Section {
                Cell(title: "Block Number", value: blockNumber)
                Cell(title: "Block Hash", value: log.blockHash, lineLimit: nil)
            }
        }
        #if !os(tvOS)
        .textCase(nil)
        #endif
    }
}

fileprivate typealias Cell = TransactionInfoCell
struct TransactionInfoCell: View {
    let title: String
    var value: String?
    var lineLimit: Int? = 1
    
    var body: some View {
        if let value, !value.isEmpty {
            VStack(alignment: .leading){
                Text(title)
                    .fontWeight(.semibold)
                Text(value)
                    .foregroundStyle(.secondary)
                    .lineLimit(lineLimit)
                    .optional(lineLimit) { view, _ in
                        view
                            .minimumScaleFactor(0.7)
                    }
            }
//            .cellBackground(padding: 14, cornerRadius: 16)
        }
    }
}

#Preview {
    TransactionInfoView(tx: CocciWallet.Transaction.generatedDummyData.first!)
}
