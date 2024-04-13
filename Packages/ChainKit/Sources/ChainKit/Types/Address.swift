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

extension Address {
    
    init?<A:AccountProtocol>(_ account: A.Type = A.self, privateKey: Data) {
        if let publicKey = try? A.generatePublicKey(from: privateKey) {
            self.init(publicKey: publicKey)
        } else {
            return nil
        }
    }
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringRepresentation = try container.decode(String.self)
        self.init(stringRepresentation)
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


