//
//  File.swift
//  
//
//  Created by Michael on 4/6/24.
//

import Foundation
import Logging

public struct Litecoin: CoinType {
    public var name: String { "Litecoin" }
    public var symbol: String { "LTC" }
    public var derivation: UInt32 { 2 }
}

public struct LitecoinAddress: WIFAddress {
    public static var prefix: UInt8 = 0x30
    
    
    private let raw: String
    public var string: String { raw }
    public var data: Data? { raw.decodeBase58Check }
    
    public init(_ string: String) {
        self.raw = string.lowercased()
    }

    public init(publicKey: Data) {
        let hash = publicKey.sha256.ripemd160
        let data = Data([0x30]) + hash
        let address = data.encodeBase58Check
        self.init(address)
    }

}

public class LitecoinAccount: WIFAccount {
    
    private let privateKey: Data
    private let publicKey: Data
    
    private let logger: Logger
    
    public lazy var address: LitecoinAddress = LitecoinAddress(publicKey: self.publicKey)
    
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

extension LitecoinAccount {
    public static let prefix: UInt8 = 0xb0
}
