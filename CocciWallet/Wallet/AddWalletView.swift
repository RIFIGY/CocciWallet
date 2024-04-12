//
//  AddWalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import Web3Kit
import KeychainSwift
import ChainKit
import SwiftData

typealias WalletGenerator = PrivateKeyGenerator<Web3Kit.EthereumAccount>

struct AddWalletView: View {

    @Environment(\.modelContext) private var context
    @Environment(Navigation.self) private var navigation
    var generator: WalletGenerator = WalletGenerator(storage: KeychainSwift.shared)
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(WalletOption.allCases) { option in
                    NavigationLink(value: option) {
                        VStack(alignment: .leading) {
                            Image(systemName: option.symbol)
                                .font(.title)
                                .foregroundStyle(option.color)
                            Text(option.title)
                                .font(.title)
                            Text(option.description)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("New Wallet")
            .navigationDestination(for: WalletOption.self) { option in
                NewWalletView(generator: generator, option: option) { wallet in
                    context.insert(wallet)
                    navigation.selected = wallet
                }
            }
        }
    }
}

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
                Button(title) {
                    cta()
                }
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
                    address = try generator.create(password: "").string
                case .privateKey:
                    address = try generator.importWallet(input, passsword: "").string
                case .watch:
                    #warning("add validate")
                    address = input
                }
            
            var type: Wallet.Kind {
                switch option {
                case .new: .key
                case .privateKey: .key
                case .watch: .watch
                }
            }
            
            let wallet = Wallet(
                address: .init(address),
                name: name,
                type: type
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


enum WalletOption: String, CaseIterable, Identifiable, Hashable {
    case new, privateKey, watch
    var id: String { self.rawValue }
    var title: String { self.rawValue.capitalized }
    var symbol: String {
        switch self {
        case .watch:
            return "magnifyingglass"
        case .privateKey:
            return "key"
        case .new:
            return "wallet.pass"
        }
    }
    
    var description: String {
        switch self {
        case .watch:
            return "Add a watch-only wallet to monitor the balance and transactions of an existing address. With this wallet, you can view incoming and outgoing transactions but cannot initiate transactions."
        case .privateKey:
            return "Import a wallet using a private key, a cryptographic key granting access to your wallet's funds. This option is suitable for restoring wallets or importing wallets created externally."
        case .new:
            return "Create a new wallet to establish a fresh account. By generating new cryptographic keys, you gain complete control over your funds. Remember to securely store your mnemonic phrase or private key for future access."
        }
    }


    
    var color: Color {
        switch self {
        case .watch:
            return .blue
        case .privateKey:
            return .orange
        case .new:
            return .purple
        }
    }

    
}


#Preview {
    AddWalletView()
}
