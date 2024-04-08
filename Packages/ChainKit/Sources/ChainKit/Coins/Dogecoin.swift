//
//  File.swift
//
//
//  Created by Michael on 4/6/24.
//

import Foundation
import Logging

public struct Dogecoin: CoinType {
    public var name: String { "Dogecoin" }
    public var symbol: String { "DOGE" }
    public var derivation: UInt32 { 3 }
}

public struct DogecoinAddress: WIFAddress {
    public static var prefix: UInt8 = 0x1e
    
    
    private let raw: String
    
    public init(_ string: String) {
        self.raw = string.lowercased()
    }

    public var string: String { raw }
    public var data: Data? { raw.decodeBase58Check }
}

public class DogecoinAccount: WIFAccount {
    public static let prefix: UInt8 = 0x9e

    private let privateKey: Data
    private let publicKey: Data
    
    private let logger: Logger
    
    public lazy var address: DogecoinAddress = DogecoinAddress(publicKey: self.publicKey)
    
//    required public init(privateKey: Data, logger: Logger? = nil) throws {
//        self.privateKey = privateKey
//        self.publicKey = try Self.generatePublicKey(from: privateKey)
//        self.logger = logger ?? Logger(label: "chankit.litecoin-account")
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
