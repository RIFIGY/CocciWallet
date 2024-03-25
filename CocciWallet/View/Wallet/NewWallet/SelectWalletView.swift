//
//  SelectWalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI

struct SelectWalletView: View {
    @AppStorage("last_selected_wallet") private var selectedWallet: String = ""
    @Environment(WalletHolder.self) private var manager
    @Environment(\.dismiss) var dismiss
    
    @State private var showNewWallet = false
    
    @State private var showingDeleteAlert = false
    @State private var walletToDelete: WalletModel?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(manager.wallets) { wallet in
                        Button {
                            self.selectedWallet = wallet.id
                            manager.selected = manager.wallets.first{ $0.id == wallet.id }
                            dismiss()
                        } label: {
                            HStack {
                                VStack {
                                    Text(wallet.name)
                                    Text(wallet.address)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: wallet.type.systemImage)
                                    .foregroundStyle(wallet.type.color)

                            }
                        }
                        .foregroundStyle(.primary)
                        .deleteAction {
                            self.walletToDelete = wallet
                        }
                    }
                }
            }
            .navigationTitle("Choose Wallet")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button{
                        showNewWallet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .presentationDetents([.medium])
            .sheet(isPresented: $showNewWallet) {
                AddWalletView { wallet in
                    manager.add(wallet: wallet)
                    self.selectedWallet = wallet.id
                    dismiss()
                }
            }
            .alert("Delete Wallet", isPresented: presentAlert, presenting: walletToDelete) { wallet in
                Button("Delete", role: .destructive) {
                    deleteItem(wallet)
                }
            } message: { wallet in
                Text("Are you sure you want to delete \(wallet.name.isEmpty ? "wallet" : wallet.name) \(wallet.address)?\nThis cannot be undone or recovered")
            }
        }
    }
    
    var presentAlert: Binding<Bool> { .init {
        self.walletToDelete != nil
        } set: { newValue in
            if !newValue { self.walletToDelete = nil }
        }
    }
        
    func deleteItem(_ wallet: WalletModel) {
        Task {
            try await manager.delete(wallet: wallet)
        }
    }
}

fileprivate extension View {
    
    @ViewBuilder
    func deleteAction(_ action: @escaping () -> Void ) -> some View {
        self
            #if os(tvOS)
            .contextMenu {
                  Button(role: .destructive) {
                      action()
                  } label: {
                      Label("Delete", systemImage: "trash")
                  }
              }
            #else
            .swipeActions {
                Button("Delete", role: .destructive) {
                    action()
                }
            }
            #endif
    }
}

#Preview {
    SelectWalletView()
        .environment( WalletHolder.preview )
}
