//
//  SearchERC20View.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/7/24.
//

import SwiftUI
import Web3Kit

struct SearchERC20View: View {
    
    @State private var result: (any ERC20Protocol)? = nil
    
    var chosen: (any ERC20Protocol) async -> Void
    
    @State private var contract: String = ""
    @State private var symbol: String = ""
    @State private var name: String = ""
    @State private var decimals: Int = 18
    
    @State private var isSearching = false
    
    var icon: Icon? {
        Icon.getIcon(for: result?.symbol)
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    IconView(symbol: symbol, size: 75)
                    Spacer()
                }
                .frame(height: 75)
                .listRowBackground(Color.clear)
                Section {
                    TextField("0x....", text: $contract)
                        .onSubmit(search)
                } header: {
                    HStack {
                        Text("Contract Address")
                            .font(.caption2)
                        Spacer()
                        #if !os(tvOS)
                        Button(systemName: "circle") {
                            #if os(macOS)
                            if let paste = NSPasteboard.general.string(forType: .string) {
                                self.contract = paste
                            }
                            #else
                            if let paste = UIPasteboard.general.string {
                                self.contract = paste
                            }
                            #endif
                        }
                        #endif
                    }
                }
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
            .onChange(of: contract) { oldValue, newValue in
                if newValue.count == 42, !isSearching {
                    search()
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Add"){
                        if let result, !name.isEmpty, decimals != 0, !symbol.isEmpty, !contract.isEmpty {
                            Task {
                                await chosen(result)
                            }
                        }
                    }
                    .disabled(result == nil)
                }
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(icon?.hexColor == nil ? .hidden:.visible, for: .navigationBar)
            .toolbarBackground(icon?.hexColor ?? Color.blue)
        }
        
    }
    
    func search(){
        print("Searching \(contract)")
        self.isSearching = true
        Task {
            do {
//                let result = try await manager.client.getERC20Contract(for: contract) 
                withAnimation {
//                    self.result = result
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
    SearchERC20View { contract in
        
    }
}
