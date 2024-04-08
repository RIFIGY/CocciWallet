//
//  File.swift
//  
//
//  Created by Michael on 4/6/24.
//

import Foundation
import Logging

public struct Solana: CoinType {
    public var name: String { "Solana" }
    public var symbol: String { "SOL" }
    public var derivation: UInt32 { 501 }
}

public struct SolanaAddress: Address {
    private let raw: String
    
    public var string: String { raw }
    public var data: Data? { raw.decodeBase58 }
    
    public init(_ string: String) {
        self.raw = string
    }
    
    public init(publicKey: Data) {
        self.raw = publicKey.encodeBase58
    }
}

public class SolanaAccount: AccountProtocol {
    
    private let privateKey: Data
    private let publicKey: Data
    private let logger: Logger
    
    public lazy var address: SolanaAddress = SolanaAddress(publicKey: self.publicKey)
    
//    required public init(privateKey: Data, logger: Logger? = nil) throws {
//        self.privateKey = privateKey
//        self.publicKey = try Self.generatePublicKey(from: privateKey)
//        self.logger = logger ?? Logger(label: "chankit.ethereum-account")
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

extension SolanaAccount {
    
    
    public static func generatePublicKey(from privateKey: Data) throws -> Data {
        privateKey.suffix(32)
//        try DerivationUtil.generatePublicKey(privateKey: privateKey, curve: .ed25519, compressed: false)
    }

    public static func displayPrivateKey(from privateKey: Data) -> String {
        privateKey.encodeBase58
    }
    
    public static func importPrivateKey(_ key: String, keystorePassword password: String) throws -> Data {
        let data = key.decodeBase58
        guard data.count == 64 else {
            throw AccountError.invalidPrivateKeyFormat
        }
        return data
    }
}
