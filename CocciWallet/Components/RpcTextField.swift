//
//  RpcUrlTextField.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/26/24.
//

import SwiftUI
import Web3Kit

struct RpcTextField: View {
    
    @Binding var rpc: URL?
    let chain: Int
    var color: Color?
    var label: String?
    @Binding var validURL: Bool
    
    @State private var tested = false
    @State private var validResponse = false
    
    private var urlString: Binding<String> { .init { rpc?.absoluteString ?? "" }
        set: {
            if let url = URL(string: $0) { rpc = url }
        }
    }
    
    @ViewBuilder
    var textField: some View {
        if let label {
            HStack {
                Text(label)
                Spacer()
                TextField("RPC", text: urlString)
                #if os(iOS)
                    .keyboardType(.URL)
                #endif
                    .fixedSize()
                    .onSubmit {
                        testUrl()
                    }
            }
        } else {
            TextField("RPC", text: urlString)
                #if os(iOS)
                    .keyboardType(.URL)
                #endif
                .fixedSize()
                .onSubmit {
                    testUrl()
                }
        }

    }
    
    var body: some View {
        Section {
            Group {
                if let color {
                    IconCell(systemImage: "link", color: color) {
                        textField
                    }
                } else {
                    textField
                }
            }
            .onChange(of: urlString.wrappedValue) { oldValue, newValue in
                withAnimation {
                    self.tested = false
                    self.validResponse = false
                }
            }
        } footer: {
            HStack {
                Group {
                    if tested {
                        Circle().fill( validResponse ? Color.green : Color.red )
                    } else {
                        Circle().fill( Color.clear )
                    }
                }
                .frame(width: 10, height: 10)
                Button("Test") {
                    testUrl()
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var rpcValidated: Bool {
        if tested {
            validResponse
        } else { false }
    }
    
    func testUrl() {
        guard let url = URL(string: urlString.wrappedValue) else {return}
        let client = EthereumClient(rpc: url, chain: chain)
        Task {
            do {
                let _ = try await client.node.getGasPrice()
                withAnimation {
                    self.tested = true
                    self.validResponse = true
                }
            } catch {
                withAnimation {
                    self.tested = true
                    self.validResponse = false
                }
            }
            self.validURL = rpcValidated
        }
    }
}

extension RpcTextField {
    
    init(rpc: Binding<URL>, chain: Int, color: Color? = nil, label: String? = nil, validURL: Binding<Bool>) {
        self._rpc = Binding<URL?>(
            get: {
                rpc.wrappedValue
            },
            set: {
                if let newUrl = $0 {
                    rpc.wrappedValue = newUrl
                }
            }
        )
        self._validURL = validURL
        self.chain = chain
    }

}

#Preview {
    RpcTextField(rpc: .constant(Network.preview.rpc), chain: 1, validURL: .constant(false))
}
