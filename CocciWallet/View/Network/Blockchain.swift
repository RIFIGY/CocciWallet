//
//  File.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/25/24.
//

import SwiftUI
import BigInt

protocol BlockchainProtocol: Identifiable, Codable, Hashable, Equatable {
    associatedtype C : Coin
    var crypto: C {get}
}

extension BlockchainProtocol {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

protocol Coin: Codable {
    var symbol: String {get}
    var decimals: UInt8 {get}
}

protocol BlockchainClient {
    func getBalance(address: String) async throws -> BigUInt
}

struct Blockchain: BlockchainProtocol {

    
    typealias C = Crypto
    
    var id: String { name + "_" + crypto.symbol }
    
    let name: String
    let derivationPath: String
    let crypto: C
    let color: Color
    
    init(name: String, derivationPath: String, symbol: String, decimals: UInt8, color: Color) {
        self.name = name
        self.derivationPath = derivationPath
        self.crypto = .init(symbol: symbol, decimals: decimals)
        self.color = color
    }
    
    struct Crypto: Coin {
        let symbol: String
        let decimals: UInt8
    }
}

extension Blockchain {
    
    static let supported: [Blockchain] = [ .BTC, .LTC, .SOL, .DOGE ]
    static let BTC = Blockchain(name: "Bitcoin", derivationPath: "m/44'/0'/0'/0/0", symbol: "BTC", decimals: 8, color: Color(hex: "#f7931a")!)
    static let ETH = Blockchain(name: "Ethereum", derivationPath: "m/44'/60'/0'/0/0", symbol: "ETH", decimals: 18, color: .ETH)
    static let LTC = Blockchain(name: "Litecoin", derivationPath: "m/44'/2'/0'/0/0", symbol: "LTC", decimals: 8, color: Color(hex: "#bfbbbb")!)

    static let SOL = Blockchain(name: "Solana", derivationPath: "m/44'/501'/0'/0'", symbol: "SOL", decimals: 9, color: Color(hex: "#66f9a1")!)
    
    static let DOGE = Blockchain(name: "Dogecoin", derivationPath: "m/44'/3'/0'/0/0", symbol: "DOGE", decimals: 8, color: Color(hex: "#c3a634")!)

}


import Web3Kit
//extension Blockchain {
//    init?(evm: EVM) {
//        guard let name = evm.name, let symbol = evm.symbol else {
//            return nil
//        }
//        self.name = name
//        self.derivationPath = "m/44'/60'/0'/0/0"
//        self.crypto = .init(symbol: symbol, decimals: 18)
//        self.color = evm.color
//    }
//}
