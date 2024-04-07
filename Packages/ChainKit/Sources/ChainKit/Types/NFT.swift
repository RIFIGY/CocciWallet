//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation

protocol NFT: Identifiable, Codable {
    var name: String? {get}
    var symbol: String? {get}
}

public protocol Token: Coin {
    var platform: any CoinType { get }
    var decimals: UInt8 {get}
}
public extension Token {
    var name: String { platform.name }
    var symbol: String { platform.symbol }
}
