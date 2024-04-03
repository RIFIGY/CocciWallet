//
//  CodeScannerView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/24/24.
//

import SwiftUI
#if os(iOS)
import CodeScanner


extension View {

    func qrScanSheet(showScanner: Binding<Bool>, input: Binding<String>, walletOption: WalletOption? = nil) -> some View {
        self.modifier( CodeScannerView(input: input, showingScanner: showScanner, option: walletOption) )
    }
}

struct CodeScannerView: ViewModifier {
    @Binding var input: String
    @Binding var showingScanner: Bool
    
    let option: WalletOption?
    
    func body(content: Content) -> some View {
        content
        .sheet(isPresented: $showingScanner) {
            CodeScanner.CodeScannerView(codeTypes: [.qr], completion: handleScan)
        }
        .optional(option) {  view, option in
            view
            .toolbar {
                if option != .new {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(systemName: "qrcode.viewfinder") {
                            showingScanner = true
                        }
                    }
                }
            }
        }

    }

    func handleScan(result: Result<ScanResult, ScanError>) {
       showingScanner = false
        switch result {
        case .success(let result):
            self.input = result.string
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        Color.random
            .qrScanSheet(showScanner: .constant(true), input: .constant(""), walletOption: .privateKey)
    }
}
#endif
