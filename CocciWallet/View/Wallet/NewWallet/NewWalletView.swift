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
    @State private var password = ""
    @State private var name = ""
    
    #if os(iOS)
    @State private var showingScanner = false
    #endif
    
    var placeholder: String {
        switch option {
        case .new:
            "Name"
        case .privateKey:
            "Private Key"
        case .watch:
            "Address"
        }
    }


    var body: some View {
        Form{
            if option != .new {
                HStack {
                    TextField(placeholder, text: $input)
                    #if !os(tvOS)
                    ButtonCorner(systemImage: "doc.on.clipboard.fill", color: .ETH) {
                        paste()
                    }
                    #endif
                }
            }
            if option != .watch {
                TextField("Password (optional)", text: $password)
            }
            TextField("Name (optional)", text: $name)
            ImportButtton(title: title, action: cta)
        }
        .padding(.horizontal)
        .alert("Wallet Error", isPresented: $showError) {
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .navigationTitle("\(title) Wallet")
        #if os(iOS)
        .qrScanSheet(showScanner: $showingScanner, input: $input, walletOption: option)
        #endif
    }


    func cta(){
        do {

            let address: String
                switch option {
                case .new:
                    address = try generator.creatAccount(name: name, password: password)
                case .privateKey:
                    address = try generator.importAccount(privateKey: input, password: password, name: name)
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
          .buttonStyle(.borderedProminent)
          .tint(.blue)
          .font(.largeTitle)
          .padding(.bottom)
    }
}
//#Preview {
//    NewWalletView(option: .new)
//        .environment(WalletManager(wallets: [.rifigy]))
//}
