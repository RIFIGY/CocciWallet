//
//  WalletSettingsView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct WalletSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var wallet: Wallet
    
    
    var body: some View {
        Form {
//            Section {
//                NavigationLink {
//                    SelectWalletView(wallet: $wallet)
//                } label: {
//                    IconCell(systemImage: "wallet.pass.fill", color: .teal) {
//                        Text("Wallets")
//                    }
//                }
//            }
            Section(wallet.name) {
                IconCell(systemImage: "tray", color: .cyan) {
                    Text("Name")
                    Spacer()
                    TextField("Name", text: $wallet.name)
                        .fixedSize()
                }
//                NetworkSettingsList(wallet: wallet)
                NavigationLink {
                    WalletKeySettings(wallet: wallet)
                } label: {
                    IconCell(systemImage: "key.fill", color: .orange) {
                        Text("\(wallet.hasKey ? "Public" : "Private") Key")
                    }
                }
                IconCell(systemImage: "creditcard", color: .teal) {
                    Toggle(isOn: $wallet.settings.displayAsCards) {
                        Text("Display as Cards")
                    }
                }
                if !wallet.settings.displayAsCards {
                    IconCell(systemImage: "list.bullet.indent", color: .indigo) {
                        Toggle(isOn: $wallet.settings.groupTokens) {
                            Text("Group Tokens")
                        }
                    }
                }
            }
                    

            AppSettings(section: "App")
        }
        .navigationTitle("Settings")
    }
}



fileprivate struct NetworkSettingsList: View {
    @Binding var networks: [EthereumNetworkCard]
    
    var body: some View {
        NavigationLink {
            List {
                Section("Web3") {
                    ForEach($networks) { card in
//                        NavigationLink {
//                            NetworkCardSettings(card: card) {
//                                networks.remove(card.wrappedValue)
////                                wallet.remove(card)
//                            }
//                        } label: {
//                            IconCell(symbol: card.wrappedValue.symbol, color: card.wrappedValue.color) {
//                                Text(card.wrappedValue.name)
//                            }
//                        }
                    }
                }
            }
        } label: {
            IconCell(systemImage: "network", color: .ETH) {
                Text("Networks")
            }
        }
    }
}

struct DeleteWalletView: View {
    @Environment(\.modelContext) private var context
    let wallet: Wallet
    
    var dismiss: ()->Void
    
    @State private var isShowingConfirm = false
    @State private var error: (any Error)?
    
    var showError: Binding<Bool>{ .init {
            error != nil
        } set: {
            if !$0 { error = nil }
        }
    }
    var body: some View {
        VStack {
            Text("Are you sure you want to delete \(wallet.name)?\nThis cannot be undone or recovered, your funds will stay in your wallet but you will lose access to the wallet")
                .font(.title)
            Button("Delete", role: .destructive) {
                
            }
            .buttonStyle(.bordered)
            
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
                #warning("add auth amd delete key")
                context.delete(wallet)
                dismiss()
            } catch {
                self.error = error
            }
        }
    }
}

#Preview {
    let preview = Preview()
    return NavigationStack {
        WalletSettingsView(wallet: .rifigy)
    }

        .environmentPreview()

}
