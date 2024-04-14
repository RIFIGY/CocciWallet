//
//  SelectWalletView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI
import SwiftData


struct SelectWalletView: View {
    @AppStorage("last_selected_wallet") private var selectedWallet: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
//    @Environment(Navigation.self) private var navigation
    
    @Query private var wallets: [Wallet]
    
    @Binding var selected: Wallet?
    
    var sectioned: Bool = false
    
    @State private var showNewWallet = false
    
    @State private var showingDeleteAlert = false
    @State private var walletToDelete: Wallet?
    
    
    var sections: [Wallet.Kind: [Wallet]] {
        Dictionary(grouping: wallets, by: {$0.type})
    }
    
    var walletTypes: [Wallet.Kind] {
        Array(sections.keys)
    }

    var presentAlert: Binding<Bool> { .init {
        self.walletToDelete != nil
        } set: { newValue in
            if !newValue { self.walletToDelete = nil }
        }
    }
    
    var body: some View {
        List {
            if sectioned, wallets.count > 1 {
                ForEach(walletTypes) { walletType in
                    if let wallets = sections[walletType] {
                        Section(walletType.rawValue) {
                            Cells(for: wallets)
                        }
                    }
                }
            } else {
                Section {
                    Cells(for: wallets)
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 300, minHeight: 250)
        #endif
        .navigationTitle("Wallets")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add", systemImage: "plus") {
                    showNewWallet = true
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Back", systemImage: "chevron.left") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showNewWallet, onDismiss: { dismiss() }) {
            NavigationStack {
                AddWalletView()
                    #if os(macOS)
                    .frame(minHeight: 450)
                    //        .frame(maxWidth: 800, maxHeight: 700)
                    #endif
            }
        }
        .alert("Delete Wallet", isPresented: presentAlert, presenting: walletToDelete) { wallet in
            Button("Delete", role: .destructive) {
                context.delete(wallet)
                if selected == wallet {
                    selected = wallets.first
                }
            }
        } message: { wallet in
            Text("Are you sure you want to delete \(wallet.name.isEmpty ? "wallet" : wallet.name) \(wallet.address)?\nThis cannot be undone or recovered")
        }
    }
    
    @ViewBuilder
    func Cells(for wallets: [Wallet]) -> some View {

        ForEach(wallets) { wallet in
            Button {
                withAnimation {
                    self.selected = wallet
                }
                self.selectedWallet = wallet.id
//                navigation.select(wallet: wallet)
                dismiss()
            } label: {
                Cell(wallet: wallet)
            }
            .foregroundStyle(.primary)
            .deleteAction {
                self.walletToDelete = wallet
            }
        }
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
                Text(wallet.address.string)
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
            #if os(iOS)
            .swipeActions {
                Button("Delete", role: .destructive) {
                    action()
                }
            }
            #else
            .contextMenu {
                  Button(role: .destructive) {
                      action()
                  } label: {
                      Label("Delete", systemImage: "trash")
                  }
              }
            #endif
    }
}

#Preview {
    NavigationStack {
        SelectWalletView(selected: .constant(nil))
    }
}

#Preview {
    List {
        Cell(wallet: .rifigy)
    }
}
