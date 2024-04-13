//
//  SettingsView.swift
//  CocciWallet
//
//  Created by Michael on 4/10/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(Navigation.self) private var navigation

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
                        self.navigation.showSettings = false
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
