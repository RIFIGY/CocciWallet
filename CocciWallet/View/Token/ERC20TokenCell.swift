//
//  ERC20CellView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI
import Web3Kit

struct ERC20TokenCell: View {
    @Environment(PriceModel.self) private var priceModel

    let contract: String
    let name: String?
    let symbol: String?
    let decimals: UInt8
    let balance: BigUInt?
    let evm: EVM
    
    var icon: Icon? {
        Icon.getIcon(for: symbol)
    }
    
    var color: Color {
        icon?.hexColor ?? evm.color
    }
    
    var value: Double? {
        balance?.value(decimals: decimals)
    }
    
    var body: some View {
        HStack {
            IconView(symbol: symbol ?? "", size: 30, color: color)
            VStack(alignment: .leading) {
                Text(name ?? "Name")
                Text(symbol ?? "Symbol")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Group {
                if let value {
                    VStack(alignment: .trailing) {
                        Text(value, format: .number.precision(.fractionLength(2)))
                        if let price = priceModel.price(evm: evm, contract: contract) {
                            Text(price.0 * value, format: .currency(code: price.1))
                        }
                    }
                } else {
                    Text("--")
                }
            }
            .foregroundStyle(color)
        }
    }
}


import Web3Kit
import BigInt
extension ERC20TokenCell {
    init(_ contract: any Web3Kit.ERC20Protocol, balance: BigUInt?, evm: EVM) {
        self.name = contract.name
        self.symbol = contract.symbol
        self.decimals = contract.decimals
        self.balance = balance
        self.contract = contract.contract
        self.evm = evm
    }
}

#Preview {
    ERC20TokenCell(ERC20.USDC, balance: 353823, evm: .ETH)
        .environment(PriceModel() )
}
