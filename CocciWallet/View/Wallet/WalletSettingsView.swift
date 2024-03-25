//
//  WalletSettingsView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct WalletSettingsView: View {
    @Environment(WalletHolder.self) private var manager
    @Environment(\.dismiss) private var dismiss
    let wallet: WalletModel
    
    @State private var isShowingConfirm = false
    
    @State private var error: (any Error)?
    
    var showError: Binding<Bool>{ .init {
            error != nil
        } set: {
            if !$0 { error = nil }
        }
    }
    
    var body: some View {
        Form {
            NavigationLink {
                SelectWalletView()
                    .environment(manager)
            } label: {
                Text("Wallets")
            }
            Button("Show Key"){}
            CurrencyCell()
            Button("Delete", role: .destructive) {
                isShowingConfirm = true
            }
            .frame(maxWidth: .infinity)
        }
        .alert("Delete Wallet", isPresented: $isShowingConfirm) {
            Button("Delete", role: .destructive) {
                delete()
            }
        } message: {
            Text("Are you sure you want to delete \(wallet.name.isEmpty ? "wallet" : wallet.name) \(wallet.address)?\nThis cannot be undone or recovered")
        }
        .alert("Error", isPresented: showError, presenting: error) { error in
            Button("Retry") {
                delete()
            }
        } message: { error in
            Text(error.localizedDescription)
        }

    }
    
    func delete(){
        Task {
            do {
                try await manager.delete(wallet: wallet)
                dismiss()
            } catch {
                self.error = error
            }
        }
    }
}

import Web3Kit
struct CurrencyCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    
    var body: some View {
        HStack {
            Text("Currency")
            Spacer()
            Menu(currency) {
                ForEach(CoinGecko.Currencies, id: \.self) { currency in
                    Button(currency){
                        self.currency = currency
                    }
                }
            }
        }
    }
}

#Preview {
    WalletSettingsView(wallet: .rifigy)
}
