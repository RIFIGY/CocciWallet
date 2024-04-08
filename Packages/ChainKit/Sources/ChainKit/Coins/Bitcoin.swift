//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import Logging

public struct Bitcoin: CoinType {
    public var name: String { "Bitcoin" }
    public var symbol: String { "BTC" }
    public var derivation: UInt32 { 0 }
}

public struct BitcoinAddress: WIFAddress {
    public static let prefix: UInt8 = 0x00
    private let raw: String
    
    public init(_ string: String) {
        self.raw = string.lowercased()
    }
    
    public var string: String { raw }
    public var data: Data? { raw.decodeBase58Check }
}

public class BitcoinAccount: WIFAccount {
    
    private let privateKey: Data
    private let publicKey: Data
    public static let prefix: UInt8 = 0x80

    private let logger: Logger
    
    public lazy var address: BitcoinAddress = BitcoinAddress(publicKey: self.publicKey)
    
//    required public init(privateKey: Data, logger: Logger? = nil) throws {
//        self.privateKey = privateKey
//        self.publicKey = try Self.generatePublicKey(from: privateKey)
//        self.logger = logger ?? Logger(label: "chankit.bitcoin-account")
//    }
    required public init(addressString: String, keyStorage: any PrivateKeyStorageProtocol, keystorePassword password: String, logger: Logging.Logger? = nil) throws {
        do {
            let address = Address(addressString)
            let privateKey = try keyStorage.loadAndDecryptPrivateKey(for: address, keystorePassword: password)
            self.privateKey = privateKey
            self.publicKey = try Self.generatePublicKey(from: privateKey)
            self.logger = logger ?? Logger(label: "chainkit-ethereum-account")
        } catch {
            throw AccountError.loadAccountError
        }
    }
}
