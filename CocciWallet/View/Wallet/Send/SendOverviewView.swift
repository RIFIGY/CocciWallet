//
//  SendOverviewView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/24/24.
//

import SwiftUI
import Web3Kit
import BigInt

struct SendOverviewView: View {
    @Environment(NetworkManager.self) private var network
    @Environment(WalletHolder.self) private var manager
    @Environment(PriceModel.self) private var priceModel

    @Bindable var model: SendViewModel
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    
    
    var evm: EVM { model.evm }
    var from: String { model.address }
    var decimals: UInt8 { model.decimals }
        
    
    let gasDisplayUnit: Double = 1e9
    
    var gasPriceString: String? {
        guard let gasPrice = model.gasPrice else {return nil}
        return ( Double(gasPrice) / gasDisplayUnit ).string(decimals: 8)
    }
    
    var estimatedGasString: String? {
        guard let estimatedGas = model.estimatedGas else {return nil}
        let value = Double(estimatedGas) / gasDisplayUnit
        return value.string(decimals: 8)
    }
    
    var value: BigUInt? {
        guard let amount = model.amount else {return nil}
        if model.amountIsInCrypto {
            return amount.bigValue(decimals: decimals)
        } else if let (price, _) = priceModel.price(evm: model.evm) {
            return (amount / price).bigValue(decimals: decimals)
        } else {
            return nil
        }
    }
    
    var amountValue: Double? {
        guard let amount = model.amount else {return nil}
        if model.amountIsInCrypto {
            return amount
        } else if let (price, _) = price {
            return amount / price
        } else {
            return nil
        }

    }
    var price: (Double, String)? { priceModel.price(evm: model.evm) }

    
    var body: some View {
        Form {
            
            Section("From"){
                Text(model.address)
            }
            
            Section("To") {
                Text(model.to)
            }

            if let amountValue {
                
                Section {
                    Text(amountValue, format: .number.grouping(.automatic))
                        .font(.title)
                } header: {
                    if let (price, currency) = price {
                        Text(amountValue * price,
                             format: .currency(code: currency)
                        )
                    }
                } footer: {
                    VStack(spacing: 0) {
                        if let gasPriceString {
                            Text("Gas Price: \(gasPriceString)")
                        }
                        if let estimatedGasString {
                            Text("Estimated Gas: " + estimatedGasString)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Group {
                if isSending {
                    ProgressView()
                } else {
                    Button("Send"){
                        send()
                    }
                }
            }
            .font(.largeTitle.weight(.semibold))
            .padding(.vertical)
            .padding(.horizontal)
            .background(model.evm.color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.top, 64)
            
        }
        .navigationDestination(item: $model.txHash) { txHash in
            TransactionSentView(model: model, txHash: txHash)
        }
//        .onReceive(timer) { _ in
//            Task {
//                await updateGasInfo()
//            }
//        }
        .task {
            await updateGasInfo()
        }
    }
    
    private func updateGasInfo() async {
        let client = network.getClient(evm)
        await model.fetchGas(client: client)
        await model.fetchGasEstimate(value: value, client: client)
    }
    
    @State private var isSending = false
    
    private func send() {
        isSending = true
        guard let value = value else {isSending = false;return}
        let client = network.getClient(evm)
        Task {
            do {
                let account = try await manager.getAccount(for: model.address, password: "")
                
                let txHash = try await client.send(value,
                    to: model.to,
                    from: account,
                    gasPrice: model.gasPrice,
                    gasLimit: model.estimatedGas
                )
                model.txHash = txHash
                isSending = false
            } catch {
                print(error.localizedDescription)
                print(error)
                isSending = false
            }
        }
    }
}


#Preview {
    SendOverviewView(model: SendViewModel(evm: .ETH, address: Wallet.rifigy.address, decimals: 18))
        .environment(NetworkManager())
        .environment(WalletHolder.preview)
        .environment(PriceModel.preview)
}
