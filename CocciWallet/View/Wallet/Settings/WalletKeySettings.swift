//
//  WalletKeySettings.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI

struct WalletKeySettings: View {
    @Environment(WalletHolder.self) private var manager
    @Environment(\.dismiss) private var dismiss

    @Bindable var wallet: Wallet
    
    @State private var privateKey: Data?
    @State private var showAddress = false
    
    var body: some View {
        Form {
            Section {
                if wallet.type != .watch {
                    
                    IconCell(systemImage: "key.fill", color: .orange) {
                        Text("Show Private Key")
                    }
                    .onTapGesture {
                        Task {
                            self.privateKey = try await manager.getPrivateKey(for: wallet.address)
                        }
                    }
                    NavigationLink {
                    } label: {
                        IconCell(systemImage: "key.icloud.fill", color: .blue) {
                            VStack {
                                Text("Backup Private Key")
                            }
                        }
                    }
                } else {
                    IconCell(systemImage: "circle", color: .teal) {
                        Text("Show Address")
                    }
                    .onTapGesture {
                        self.showAddress = true
                    }
                }
            }
            Section {
                NavigationLink {
                    DeleteWalletView(wallet: wallet) {
                        dismiss()
                    }
                    .environment(manager)
                } label: {
                    CellIcon(systemImage: "trash.fill", color: .red) {
                        Text("Delete").foregroundStyle(.red)
                    }
                }
                .foregroundStyle(.red)
            }
        }
        .navigationDestination(item: $privateKey) { data in
            AddressView(name: wallet.name, privateKey: data, export: export(key:))
        }
        .navigationDestination(isPresented: $showAddress) {
            AddressView(address: wallet.address, name: wallet.name, share: export(address:))
        }
    }
    
    func export(address: String) async {
        
    }
    
    func export(key: String) async {
        do {
            let key = try await manager.getAccount(for: wallet.address)
            print(key.publicKey)
        } catch {
            print(error)
        }
    }
}

#Preview {
    WalletKeySettings(wallet: .rifigy)
}
