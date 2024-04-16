//
//  SettingsView.swift
//  CocciWallet
//
//  Created by Michael on 4/10/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selection: Wallet?
    var body: some View {
        NavigationStack {
            Group {
                if let selection  {
                    WalletSettingsView(wallet: selection)
                } else {
                    Form {
                        AppSettings()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back", systemImage: "chevron.left") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    SettingsView()
//        .environmentPreview()
//}
