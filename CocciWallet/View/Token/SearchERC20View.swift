//
//  SearchERC20View.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/7/24.
//

import SwiftUI
import Web3Kit
import OffChainKit
import ChainKit

struct SearchERC20View: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(NetworkManager.self) private var network
    @State private var result: (any Contract)? = nil
    
    let chain: Int
    var chosen: (any Contract) async -> Bool
    
    @State private var contract: String = ""
    @State private var symbol: String = ""
    @State private var name: String = ""
    @State private var decimals: Int = 18
    
    @State private var isSearching = false
    
    var icon: Icon? {
        Icon(symbol: result?.symbol)
    }
    
    @State private var validContract = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    IconView(symbol: result?.symbol ?? symbol, size: 75)
                    Spacer()
                }
                .frame(height: 75)
                .listRowBackground(Color.clear)
                EthTextField(
                    placeholder: "0x...",
                    header: "Contract Address",
                    toolbar: false,
                    color: icon?.color,
                    input: $contract,
                    isValid: $validContract
                )

                Section {
                    if let symbol = result?.symbol {
                        Text(symbol)
                    } else {
                        TextField("ETH", text: $symbol)
                    }
                } header: {
                    Text("Symbol")
                        .font(.caption2)

                }
                Section{
                    if let decimal = result?.decimals {
                        Text(decimal.description)
                    } else {
                        TextField("18", value: $decimals, format: .number)
                    }
                } header: {
                    Text("Decimals")
                        .font(.caption2)

                }
                
                Section {
                    if let name = result?.name {
                        Text(name)
                    } else {
                        TextField("Token", text: $name)
                    }
                } header: {
                    Text("Name")
                        .font(.caption2)
                }
            }
//            .onChange(of: contract) { oldValue, newValue in
//                if newValue.count == 42, !isSearching {
//                    search()
//                }
//            }
            .onChange(of: validContract) { oldValue, newValue in
                if newValue {
                    search()
                } else if oldValue {
                    self.result = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Add"){
                        Task {
                            if let result {
                                if await chosen(result) {
                                    dismiss()
                                } else {
                                    showError = true
                                }
                            } else if !name.isEmpty, decimals != 0, !symbol.isEmpty, !contract.isEmpty {
                                showError = true
                            }
                            
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(icon?.color ?? .ETH)
                    .disabled(result == nil)
                }
            }
            .alert("Existing Token", isPresented: $showError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text("You already have this Token in your list")
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(icon?.hexColor == nil ? .hidden:.visible, for: .navigationBar)
//            .toolbarBackground(icon?.hexColor ?? Color.blue)
        }
        
    }
    
    func search(){
        print("Searching \(contract)")
        guard let client = network.getClient(chain: chain) else {return}
        self.isSearching = true
        Task {
            do {
                let result = try await client.node.getContract(address: contract)
                withAnimation {
                    self.result = result
                }
                self.isSearching = false
            } catch {
                print(error)
                self.isSearching = false
            }
        }
    }
}

#Preview {
    SearchERC20View(chain: 1) { contract in
        true
    }
}
