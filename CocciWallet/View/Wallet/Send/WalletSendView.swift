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
    @AppStorage("currency") private var currency = "usd"
    @Environment(WalletHolder.self) private var manager
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
            ToAddressField(model: model)
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
                let client = network.getClient(model.evm)
                model.gasPrice = try await client.getGasPrice()
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

fileprivate struct ToAddressField: View {
    
    @Bindable var model: SendViewModel
    @State private var displayedAddress: String = ""

    @FocusState private var isFocused: Bool
    
    #if os(iOS)
    @State private var showingScanner = false
    #endif
    
    var body: some View {
        Section {
            TextField("0x...", text: $displayedAddress)
                .focused($isFocused)
                .onChange(of: isFocused) { _, newValue in
                     if newValue {
                         displayedAddress = model.to
                     } else if model.to.isEthereumAddress {
                         model.to = displayedAddress
                         displayedAddress = model.to.shortened(10, 6)
                     }
                 }
                 .onChange(of: displayedAddress) { _, newValue in
                     // Update model.to only when the field is focused to prevent overwriting with the shortened version
                     if isFocused {
                         model.to = newValue
                     }
                 }
                 .onAppear {
                     if model.to.isEthereumAddress {
                         self.displayedAddress = model.to.shortened(10, 6)
                     } else {
                         self.displayedAddress = model.to
                     }
                 }
                #if os(iOS)
                 .qrScanSheet(showScanner: $showingScanner, input: $displayedAddress)
                #endif
        } header: {
            Text("To")
        } footer: {
            HStack {
                Group {
                    if !model.to.isEmpty, !isFocused, !model.to.isEthereumAddress {
                        Text("Invalid Address")
                            .foregroundStyle(.red)
                    } else if model.to.isEthereumAddress {
                        Text("Valid Address")
                            .foregroundStyle(.green)
                    }
                }
                .font(.footnote)
                Spacer()
                #if os(iOS)
                Button(systemName: "qrcode"){
                    showingScanner = true
                }
                .foregroundStyle(model.evm.color)
                #endif
                Button(systemName: "doc.on.clipboard.fill") {
                    if let paste = Pasteboard.paste() {
                        self.displayedAddress = paste
                    }
                }
                .foregroundStyle(model.evm.color)
            }
            
        }
    }
}

fileprivate struct AmountTextField: View {
    @AppStorage("currency") private var currency = "usd"
    @Environment(PriceModel.self) private var priceModel
    
    @Bindable var model: SendViewModel

    @Namespace private var animation

    var price: (Double, String)? { priceModel.price(evm: model.evm) }
    
    var body: some View {
        Section {
            TrailingTextField(placeholder: "0", value: $model.amount, native: model.evm.symbol ?? "COIN", valueIsInCrypto: model.amountIsInCrypto)

        } header: {
            if model.amountIsInCrypto {
                Text(model.evm.symbol ?? "Amount")
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
        if let (price, currency) = price, let amount = model.amount {
            if model.amountIsInCrypto {
                Text(amount * price,
                     format: .currency(code: currency)
                )
                .matchedGeometryEffect(id: "footer_animation", in: animation)
            } else {
                Text(amount / price,
                     format: .symbol(model.evm.symbol ?? "")
                )
                .matchedGeometryEffect(id: "footer_animation", in: animation)
            }
        }
    }
}

fileprivate struct TrailingTextField: View {
    @AppStorage("currency") private var currency = "usd"
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



extension WalletSendView {
    
    init(address: String,
         evm: EVM,
         decimals: UInt8
    ) {
        self._model = .init(wrappedValue: .init(
            evm: evm,
            address: address,
            decimals: decimals)
        )
    }
}


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

#Preview {
    WalletSendView(address: Wallet.rifigy.address, evm: .ETH, decimals: 18)
        .environment(PriceModel.preview)
        .environment(WalletHolder.preview)
        .environment(NetworkManager())
}
