//
//  TokenSettings.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import SwiftUI

struct TokenSettings: View {
    @Bindable var token: Token
    @Binding var blocklist: [String]
    
    var onBlockList: Bool {
        blocklist.map{$0.lowercased()}.contains(token.address.lowercased())
    }
    
    var body: some View {
        List {
            Button(onBlockList ? "Unblock" : "Block") {
                blocklist.append(token.address)
            }
            .foregroundStyle(onBlockList ? Color.blue : Color.red)
        }
    }
}

#Preview {
    TokenSettings(token: .USDC, blocklist: .constant([]))
}
