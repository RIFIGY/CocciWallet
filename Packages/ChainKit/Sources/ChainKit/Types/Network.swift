//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation

public protocol BlockchainNetwork: Identifiable, Equatable, Hashable {
    associatedtype Address : ChainKit.Address
    var nativeCoin: Coin { get }
    var name: String {get}
    var hexColor: String {get}
    var explorerPrefix: String? {get}
}
extension BlockchainNetwork {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension BlockchainNetwork {
    public var name: String { nativeCoin.name }
    public var symbol: String { nativeCoin.symbol }
    public var decimals: UInt8 { nativeCoin.decimals }
}

public protocol EthereumNetwork: BlockchainNetwork {
    var chain: Int { get }
    var rpc: URL { get set }
}
