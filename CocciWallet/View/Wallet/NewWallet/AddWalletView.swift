//
//  AddWalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import Web3Kit
import KeychainSwift

typealias WalletGenerator = EthereumWalletGenerator<Wallet>

struct AddWalletView: View {

    var generator: WalletGenerator = WalletGenerator(storage: KeychainSwift.shared)
    var wallet: (Wallet) -> Void
    
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
                    self.wallet(wallet)
                }
            }
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
    AddWalletView { _ in }
}
