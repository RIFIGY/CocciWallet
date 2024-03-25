//
//  TransactionViewModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI
import Web3Kit

typealias TransactionProtocol = Web3Kit.TransactionProtocol

@Observable
class TransactionsModel {
    
    let address: String
    let price: (Double, String)?
    let evm: EVM
    var symbol: String? { evm.symbol }
    let decimals: UInt8
    let erc: [any ERC]
    
    init(address: String, price: (Double, String)?, evm: EVM, decimals: UInt8 = 18, erc: [any ERC] = []) {
        self.address = address
        self.price = price
        self.decimals = decimals
        self.erc = erc
        self.evm = evm
    }
}


struct TransactionSection<C:View>: View {

    let header: String
    @ViewBuilder let content: C
    
    var body: some View {
        SwiftUI.Section {
            VStack {
                content
            }
            .cellBackground(padding: 14, cornerRadius: 16)
        } header: {
            Text(header)
                .font(.title2.weight(.bold))
                .padding(.top)
        }
        .textCase(nil)
    }
}


struct TransactionIcon<I:View>: View {
    var color: Color = .black
    var size: CGFloat = 24
    var padding: CGFloat? = nil
    
    @ViewBuilder
    var content: I
    
    var body: some View {
        RoundedView(color: color, foreground: .white, size: size, padding: padding) {
            content
        }
    }
}

extension TransactionIcon {
    init(systemImage: String = "list.bullet", color: Color = .black, size: CGFloat = 24, padding: CGFloat? = nil) where I == Image {
        self.color = color
        self.size = size
        self.padding = padding
        self.content = Image(systemName: systemImage).resizable()
    }
    
    init(symbol: String?, evm: EVM, size: CGFloat = 24, padding: CGFloat? = nil) where I == IconView<Image> {
        let icon = Icon.getIcon(for: symbol)
        self.color = icon?.hexColor ?? evm.color
        self.size = size
        self.padding = padding
        let sym = icon?.symbol ?? evm.symbol ?? "generic"
        self.content = IconView(symbol: sym, size: size + 6 , glyph: true)
    }
}
