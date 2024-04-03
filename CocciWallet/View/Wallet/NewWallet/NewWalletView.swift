//
//  NewWalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import Web3Kit

struct NewWalletView: View {
    let generator: WalletGenerator
    let option: WalletOption
    var wallet: (Wallet) -> Void
    
    
    @State private var error: LocalizedError?
    
    var title: String {
        switch option {
        case .new:
            "Create"
        case .privateKey:
            "Import"
        case .watch:
            "Watch"
        }
    }
    
    @State private var showError = false
    @State private var errorMessage: String = "Wallet Error"
    
    @State private var input = ""
    @State private var name = ""
    
    #if os(iOS)
    @State private var showingScanner = false
    #endif
    
    var placeholder: String {
        switch option {
        case .new:
            "My Wallet"
        case .privateKey:
            "0x...."
        case .watch:
            "0x...."
        }
    }

    @State private var validAddress = false

    var body: some View {
        Form{
            if option != .new {
                EthTextField(
                    placeholder: placeholder,
                    header: option == .privateKey ? "Private Key" : "Address",
                    input: $input,
                    isValid: $validAddress
                )
            }
            Section("Name") {
                TextField("My Wallet", text: $name)
            }
            Section {
                ImportButtton(title: title, action: cta)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }
        }
        .alert("Wallet Error", isPresented: $showError) {
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .navigationTitle("\(title) Wallet")
    }


    func cta(){
        do {

            let address: String
                switch option {
                case .new:
                    address = try generator.creatAccount(name: name, password: "")
                case .privateKey:
                    address = try generator.importAccount(privateKey: input, password: "", name: name)
                case .watch:
                    address = try generator.watchAddress(input, name: name)
                }
            
            var type: WalletKey {
                switch option {
                case .watch: .watch
                default: .privateKey
                }
            }
            
            let wallet = Wallet(
                address: address,
                name: name, 
                type: type,
                blockHD: generator.blockHD
            )
            
            self.wallet(wallet)

        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    func paste() {
        if let paste = Pasteboard.paste() {
            self.input = paste
        }
    }
    
}

struct ImportButtton: View {
    
    let title: String
    var action: ()->Void
    
    var body: some View {

        Button(title) {
            action()
        }
        .font(.title2.weight(.semibold))
        .foregroundStyle(.white)
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 16))

    }
}

import KeychainSwift
#Preview {
    NavigationStack {
        NewWalletView(generator: WalletGenerator(storage: KeychainSwift.shared), option: .new){_ in}
    }
}

#Preview {
    NavigationStack {
        NewWalletView(generator: WalletGenerator(storage: KeychainSwift.shared), option: .privateKey){_ in}
    }
}

#Preview {
    NavigationStack {
        NewWalletView(generator: WalletGenerator(storage: KeychainSwift.shared), option: .watch){_ in}
    }
}
