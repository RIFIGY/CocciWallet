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
    var body: some View {
        NavigationStack {
//            if let selected = navigation.selected {
//                WalletSettingsView(wallet: selected)
//            } else {
//                Form {
//                    AppSettings()
//                }
//            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentPreview()
}
