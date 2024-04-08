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
import ChainKit

@Observable
class Network: Codable {

    let id: String

    var nativeCoin: ChainKit.Coin
    var name: String
    private(set) var hexColor: String
    var explorerPrefix: String?
    
    var balance: BigUInt?
    var transactions: [Etherscan.Transaction] = []
        
    var lastUpdate: Date?
    var isUpdating = false
    
    init(network: any BlockchainNetwork) {
        self.id = UUID().uuidString
        self.nativeCoin = network.nativeCoin
        self.name = network.name
        self.hexColor = network.hexColor
        self.explorerPrefix = network.explorerPrefix
    }
    
    public init(nativeCoin: ChainKit.Coin, name: String? = nil, hexColor: String? = nil, explorerPrefix: String? = nil) {
        self.id = UUID().uuidString
        self.nativeCoin = nativeCoin
        self.name = name ?? nativeCoin.name
        if let hexColor, Color(hex: hexColor) != nil {
            self.hexColor = hexColor
        } else {
            self.hexColor = "#627eea"
        }
        self.explorerPrefix = explorerPrefix
    }
    
    func fetchTransactions(for address: String) async {
        do {
            self.transactions = try await Etherscan.shared.getTransactions(for: address, explorer: explorerPrefix)
        } catch{}
    }
    
    func fetchBalance<C:BlockchainClientProtocol>(address: C.Address, with client: C) async {
        do {
            let balance = try await client.fetchBalance(for: address)
            self.balance = balance
        } catch {
            print(error)
        }
    }
    
    func needUpdate() -> Bool {
        guard let lastUpdate = lastUpdate else { return true }
        return lastUpdate < Date.now.addingTimeInterval(-3600)
    }

}

extension Network {
    
    var color: Color {
        Color(hex: hexColor)!
    }

    var value: Double? {
        balance?.value(decimals: nativeCoin.decimals)
    }
    
    var isCustom: Bool {
        id.count > 20
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
