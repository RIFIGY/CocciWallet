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
    
    var sectioned: Bool = false
    
    @State private var showNewWallet = false
    
    @State private var showingDeleteAlert = false
    @State private var walletToDelete: Wallet?
    
    var sections: [WalletKey: [Wallet]] { 
        Dictionary(grouping: manager.wallets, by: {$0.type})
    }

    var body: some View {
        List {
            if sectioned {
                ForEach(Array(sections.keys)) { walletType in
                    if let wallets = sections[walletType] {
                        Section(walletType.rawValue) {
                            Cells(for: wallets)
                        }
                    }
                }
            } else {
                Section {
                    Cells(for: manager.wallets)
                }
            }
        }
        .navigationTitle("Wallets")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button{
                    showNewWallet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewWallet) {
            AddWalletView { wallet in
                manager.add(wallet: wallet)
                select(wallet)
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
    
    @ViewBuilder
    func Cells(for wallets: [Wallet]) -> some View {
        ForEach(wallets) { wallet in
            Button {
                select(wallet)
            } label: {
                Cell(wallet: wallet)
            }
            .foregroundStyle(.primary)
            .deleteAction {
                self.walletToDelete = wallet
            }
        }
    }
    
    var presentAlert: Binding<Bool> { .init {
        self.walletToDelete != nil
        } set: { newValue in
            if !newValue { self.walletToDelete = nil }
        }
    }
        
    func deleteItem(_ wallet: Wallet) {
        Task {
            try await manager.delete(wallet: wallet)
        }
    }
    
    func select(_ wallet: Wallet) {
        self.selectedWallet = wallet.id
        withAnimation {
            manager.select(wallet)
        }
        dismiss()
    }
}

fileprivate struct Cell: View {
    let wallet: Wallet
    
    var body: some View {
        HStack {
            Image(systemName: wallet.type.systemImage)
                .font(.title)
                .foregroundStyle(wallet.type.color)
            VStack(alignment: .leading) {
                Text(wallet.name)
                    .fontWeight(.semibold)
                Text(wallet.address)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical,2)
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
    NavigationStack {
        SelectWalletView()
            .environment( WalletHolder.preview )
    }
}

#Preview {
    List {
        Cell(wallet: .rifigy)
    }
}
