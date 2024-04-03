//
//  ChooseNetworkView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/8/24.
//

import SwiftUI
import Web3Kit

struct AddCustomNetworkView: View {
    
    @State private var name: String = ""
    @State private var chainId: Int?
    @State private var symbol: String = ""
    @State private var rpc: URL?
    
    var network: (EVM) -> Void
    
    var body: some View {
        Form {
            CustomNetworkView(name: $name, chainId: $chainId, symbol: $symbol, rpc: $rpc, network: network)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add", action: checkValues)
                    .disabled(!validValues)
            }
        }
    }
    
    var validValues: Bool {
        guard rpc != nil, let chainId else {return false}
        return chainId > 0
    }
    
    func checkValues(){
        guard let rpc, let chainId, validValues else {return}
        let name = name.isEmpty ? "Chain \(chainId)" : name
        let symbol = symbol.isEmpty ? "COIN" : symbol
        let evm = EVM(rpc: rpc, chain: chainId, name: name, symbol: symbol, explorer: nil, hexColor: nil, isCustom: true)
        
        self.network(evm)
        
    }
}

struct CustomNetworkView: View {
    @Binding var name: String
    @Binding var chainId: Int?
    @Binding var symbol: String
    @Binding var rpc: URL?

    var network: (EVM) -> Void = {_ in }
    
    @State private var validRpc = false
    
    var body: some View {
        Section {
            TextField("Network (optional)", text: $name)
        } header: {
            Text("Network Name")
        }
        Section {
            TextField("Chain ID", value: $chainId, format: .number.grouping(.never))
            #if os(iOS)
                .keyboardType(.numberPad)
            #endif
        } header: {
            Text("Chain ID")
        }
        RpcTextField(rpc: $rpc, chain: chainId ?? 0, validURL: $validRpc)

        Section {
            TextField("Symbol (optional)", text: $symbol.max(6))
        } header: {
            Text("Symbol")
        }
    }
}

extension CustomNetworkView {
    
    init(name: Binding<String>, chainId: Binding<Int>, symbol: Binding<String?>, rpc: Binding<URL>) {
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
        self._name = name

        self._chainId = Binding<Int?>(
            get: {
                chainId.wrappedValue
            },
            set: {
                if let chain = $0 {
                    chainId.wrappedValue = chain
                }
            }
        )
        self._symbol = Binding<String>(
            get: {
                symbol.wrappedValue ?? ""
            },
            set: {
                symbol.wrappedValue = $0.isEmpty ? nil : $0
            }
        )
    }

}

#Preview{
    AddCustomNetworkView{ network in
    }
}



//struct NetworkButton: View {
//
//    var body: some View {
//        let network = Bindable(network)
//
//        Button {
//            self.network.showChangeNetwork = true
//        } label: {
//            Text(self.network.name ?? "Network")
//                .padding(.horizontal)
//                .background(Color.white)
//                .clipShape(.capsule)
//        }
//        .optional(self.network.network?.color){ view, color in
//            view.foregroundStyle(color)
//        }
//        .sheet(isPresented: network.showChangeNetwork) {
//            ChooseNetworkView()
//        }
//    }
//}

//struct ChooseNetworkView: View {
//    @Environment(NetworkManager.self) private var network
//    @Environment(\.dismiss) private var dismiss
//    @State private var addNetwork = false
//    
//    var body: some View {
//        List {
//            ForEach(EVM.selection) { evm in
//                Button {
//                    network.change(network: evm)
//                    dismiss()
//                } label: {
//                    HStack {
//                        if let symbol = evm.symbol {
//                            IconView(symbol: symbol, size: 40) {
//                                ZStack {
//                                    Circle().fill(evm.color ?? .ETH)
////                                    Text(String(evm.name.first!))
////                                        .foregroundStyle(.white)
//                                }
//                            }
//                        }
//                        VStack(alignment: .leading){
//                            Text(evm.title ?? evm.name ?? evm.chain.description)
//                                .font(.title3)
//                            Text(evm.chain.description)
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                }
//                .foregroundStyle(.primary)
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Button(systemName: "plus") {
//                    self.addNetwork = true
//                }
//            }
//        }
//        .navigationDestination(isPresented: $addNetwork) {
//            CustomNetworkView{ network in
//                self.network.change(network: network)
//                self.addNetwork = false
//            }
//        }
//    }
//}

