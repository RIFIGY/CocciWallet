//
//  File 2.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation

public protocol Address: Codable, Hashable, Identifiable, Equatable, ExpressibleByStringLiteral {
    var string: String { get }
    
    init(_ _:String)
    init(publicKey: Data)
}

public extension Address {
    var id: String { string }
    
    init(stringLiteral value: String) {
        self.init(value)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        let lhs = lhs.string.lowercased()
        let rhs = rhs.string.lowercased()
        
        return lhs == rhs
    }
}


public protocol WIFAddress: Address {
    static var prefix: UInt8 { get }
}

public extension WIFAddress {
    init(publicKey: Data) {
        let hash = publicKey.sha256.ripemd160
        let data = Data([Self.prefix]) + hash
        let address = data.encodeBase58Check
        self.init(address)
    }
}


