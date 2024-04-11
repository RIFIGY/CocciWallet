//
//  EthTextField.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/27/24.
//

import SwiftUI
import Web3Kit

struct EthTextField: View {
    let placeholder: String
    let header: String
    var toolbar: Bool = false
    var color: Color? = nil
    
    @Binding var input: String
    @Binding var isValid: Bool
    
    @State private var showingScanner = false
    
    @State private var displayedAddress: String = ""
    @FocusState private var isFocused: Bool

    
    var valid: Bool {
        input.isEthereumAddress
    }
    
    var body: some View {
        Section {
            TextField(placeholder, text: $displayedAddress)
            .focused($isFocused)
            .onChange(of: isFocused) { _, newValue in
                 if newValue {
                     displayedAddress = input
                 } else if input.isEthereumAddress {
                     input = displayedAddress
                     displayedAddress = input.shortened(10, 6)
                 }
             }
            .onChange(of: displayedAddress) { _, newValue in
                if isFocused {
                    input = newValue
                }
            }
            .onChange(of: input) { oldValue, newValue in
                withAnimation {
                    self.isValid = valid
                }
            }
            .onAppear {
                if input.isEthereumAddress {
                    self.displayedAddress = input.shortened(10, 6)
                } else {
                    self.displayedAddress = input
                }
            }
            #if os(iOS)
            .qrScanSheet(showScanner: $showingScanner, input: $input)
            #endif
            .conditional(toolbar) { view in
                view.toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(systemName: "qrcode.viewfinder") {
                            showingScanner = true
                        }
                    }
                }
            }
        } header: {
            Text(header)
        } footer: {
            HStack {
                if input.count > 5 {
                    Group {
                        if valid {
                            Text("valid adresss")
                                .foregroundStyle(.green)
                                .font(.caption)
                        } else {
                            Text("invalid adresss")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                Spacer()
                if !toolbar {
                    #if canImport(CodeScanner)
                    Button(systemName: "qrcode") {
                        self.showingScanner = true
                    }
                    .foregroundStyle(color ?? Color.ETH)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    #endif
                }
                #if !os(tvOS)
                Button(systemName: "doc.on.clipboard.fill") {
                    if let paste = Pasteboard.paste() {
                        self.displayedAddress = paste
                        self.isFocused = true
                    }
                }
                .foregroundStyle(color ?? Color.ETH)
                #endif
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var input = ""
        @State var isValid = false
        var body: some View {
            NavigationStack {
                Form {
                    EthTextField(
                        placeholder: "Placeholder",
                        header: "Header",
                        input: $input, isValid: $isValid
                    )
                }
            }
        }
    }
    
    return Preview()
}
