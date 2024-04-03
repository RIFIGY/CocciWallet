//
//  AddressView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI

struct AddressView: View {
    let address: String
    let name: String
    
    var share: (String) async -> Void = {_ in}
    
    var body: some View {
        VStack {
            qrView
            ButtonCorner(systemImage: "doc.on.doc.fill", color: .blue) {
                Pasteboard.copy(address)
            }
            Button("Copy") {
                Pasteboard.copy(address)
            }
            .font(.callout.weight(.semibold))
            Spacer()
        }
        .navigationTitle(name)
//        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(systemName: "square.and.arrow.up") {
                    Task {
                        await share(address)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var qrView: some View {
        #if canImport(UIKit)
        QRCodeView(address)
            .frame(maxHeight: 300)
            .padding([.top, .horizontal], 32)
        Text(address)
            .lineLimit(nil)
            .minimumScaleFactor(0.6)
            .padding(.horizontal)
        #else
        Text(address)
            .font(.title3)
            .padding(.horizontal)
        #endif
    }
}

typealias PrivateKeyView = AddressView
extension AddressView {
    init(name: String, privateKey key: Data, export: @escaping (String) async -> Void) {
        self.name = name
        self.address = key.web3.keccak256.web3.hexString
        self.share = export
    }
}

#Preview {
    AddressView(address: Wallet.wallet.address, name: "Wallet")
}
