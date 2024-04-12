//
//  WalletSendView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/23/24.
//

import SwiftUI
import Web3Kit
import BigInt
import web3
import KeychainSwift


struct WalletSendView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    @Environment(NetworkManager.self) private var network
    @Environment(PriceModel.self) private var priceModel
    
    @State private var model: SendViewModel
        
    @State private var showNext = false
    private var amountInCrypto: Bool {
        model.amountIsInCrypto
    }
        
    @State private var test = ""
    var body: some View {
        Form{
            FromAddressText(from: $model.address)
            EthTextField(placeholder: "0x...", header: "To", input: $model.to, isValid: .constant(false))
            AmountTextField(model: model)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Next") {
                    if !model.to.isEmpty, model.to.isEthereumAddress, let amount = model.amount, amount > 0 {
                        showNext = true
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showNext) {
            SendOverviewView(model: model)
        }
        .task {
            do {
                guard let client = network.getClient(chain: model.evm.chain, rpc: model.evm.rpc) else {return}
                model.gasPrice = try await client.node.getGasPrice()
            } catch {
                print(error)
            }
        }
        .onChange(of: model.done) {_, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    var signMessage: some View {
        VStack {
            Button("Sign"){
                
            }
        }
    }

}

fileprivate enum FocusedField:String {
    case to, amount, test
}

fileprivate struct FromAddressText: View {
    @Binding var from: String
    
    @State private var showFull = false
    
    
    var body: some View {
        Section("From") {
            Group {
                if showFull {
                    Text(from)
                        .lineLimit(0) // Allow unlimited line wrapping
                        .minimumScaleFactor(0.5) // Ensure no scaling
                } else {
                    Text(from.shortened(10, 6) )
                }
            }
            .onTapGesture {
                withAnimation {
                    showFull.toggle()
                }
            }
        }
        
    }
}


fileprivate struct AmountTextField: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var model: SendViewModel

    @Namespace private var animation

    var price: Double? { priceModel.price(chain: model.evm.chain, currency: currency) }
    
    var body: some View {
        Section {
            TrailingTextField(placeholder: "0", value: $model.amount, native: model.evm.symbol, valueIsInCrypto: model.amountIsInCrypto)

        } header: {
            if model.amountIsInCrypto {
                Text(model.evm.symbol)
                .matchedGeometryEffect(id: "header_animation", in: animation)

            } else {
                Text(currency)
                .matchedGeometryEffect(id: "header_animation", in: animation)

            }
        } footer: {
            footer
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                Button(systemName: "rectangle.2.swap"){
                    withAnimation {
                        model.amountIsInCrypto.toggle()
                    }
                }
            }

        }
    }
    
    
    
    @ViewBuilder
    var footer: some View {
        if let price, let amount = model.amount {
            if model.amountIsInCrypto {
                Text(amount * price,
                     format: .currency(code: currency)
                )
                .matchedGeometryEffect(id: "footer_animation", in: animation)
            } else {
                Text(amount / price,
                     format: .symbol(model.evm.symbol)
                )
                .matchedGeometryEffect(id: "footer_animation", in: animation)
            }
        }
    }
}

fileprivate struct TrailingTextField: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency = "usd"
    let placeholder: String
    @Binding var value: Double?
    let native: String
    
    let valueIsInCrypto: Bool
    
    
    var textField: some View {
        if valueIsInCrypto {
            TextField("0", value: $value, format: .number.grouping(.automatic))
        } else {
            TextField("0", value: $value, format: .currency(code: currency))
            
        }
    }
    
    var currencySting: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self.currency
        return formatter.currencySymbol
    }

    var body: some View {
        Group {
            HStack(spacing: 0) {
                if !valueIsInCrypto {
                    Text(currencySting)
                        .font(.callout).hidden()
                    Text(verbatim: " ")
                }
                TextField("0", value: $value, format: .number.grouping(.automatic))
                    .textFieldStyle(.plain)
    //                .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.7)
                    .font(.system(size: 72))
                if valueIsInCrypto {
                    Text(verbatim: " ")
                    Text(native).font(.callout).hidden()
                }
            }
        }
        .background {
                HStack(spacing: 0) {
                    Spacer()
                    if !valueIsInCrypto {
                        Text(currencySting)
//                            .padding(.trailing, 72/2)
                    }
                    Text(value ?? 0, format: .number.grouping(.automatic)).hidden()
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .font(.system(size: 72))
                    Text(verbatim: " ")
                    if valueIsInCrypto {
                        Text(native)
                            .font(.callout)
                    }
                    Spacer()
                }
                
                //            .fixedSize()
                //            .frame(maxWidth: .infinity, alignment: .leading)
            }
    }
}


//
//extension WalletSendView {
//    
//    init(address: String,
//         card: NetworkCard,
//         decimals: UInt8
//    ) {
//        let evm = EthereumNetwork(rpc: card.rpc, chain: card.chain, name: card.title, symbol: card.symbol, explorer: card.explorer, hexColor: card.color.hexString, isCustom: card.isCustom)
//
//        self._model = .init(wrappedValue: .init(
//            
//            evm: evm,
//            address: address,
//            decimals: decimals)
//        )
//    }
//}


extension WalletSendView {
    var noDomain: Data { """
        {
          "types" : {
            "EIP712Domain":[],
            "Test":[
              { "name": "test", "type": "uint64"}
            ]
          },
          "primaryType":"Test",
          "domain": {},
          "message": {
            "test": 1,
          }
        }
    """.data(using: .utf8)!
    }
    
    var typedData: TypedData {
        try! JSONDecoder().decode(TypedData.self, from: noDomain)
    }
    
}

//#Preview {
//    WalletSendView(address: Wallet.rifigy.address, card: .ETH, decimals: 18)
//        .environment(PriceModel.preview)
//        .environment(WalletHolder.preview)
//        .environment(NetworkManager())
//}
