//
//  Network.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import BigInt
import SwiftUI
import OffChainKit

@Observable
class Network: Codable {

    let id: UUID
    
    var address: String
    
    var title: String
    var symbol: String?
    var explorer: String?
    
    var hexColor: String
    var decimals: UInt8
    var isCustom: Bool
    
    var balance: BigUInt?
        
    public init(address: String, decimals: UInt8, title: String, symbol: String? = nil, explorer: String? = nil, hexColor: String? = nil, isCustom: Bool) {
        self.id = UUID()
        self.address = address
        self.title = title
        self.decimals = decimals
        self.symbol = symbol?.uppercased()
        self.explorer = explorer
        if let hexColor, Color(hex: hexColor) != nil {
            self.hexColor = hexColor
        } else {
            self.hexColor = "#627eea"
        }
        self.isCustom = isCustom
    }
    
    var color: Color { Color(hex: hexColor)! }

    var value: Double? {
        balance?.value(decimals: decimals)
    }
    
    var transactions: [Etherscan.Transaction] = []
    
    func fetchTransactions() async {
        do {
            self.transactions = try await Etherscan.shared.getTransactions(for: address, explorer: explorer)
        } catch{}
    }

}


extension Network: Identifiable, Equatable, Hashable {
    static func == (lhs: Network, rhs: Network) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
