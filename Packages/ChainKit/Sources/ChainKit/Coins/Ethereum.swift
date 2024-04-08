//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import Logging


public extension Coin {
    static let Ethereum = Coin(derivation: 60, symbol: "ETH", name: "Ethereum", decimals: 18)
}

public struct Ethereum: CoinType {
    public var name: String { "Ethereum" }
    public var symbol: String { "ETH" }
    public var derivation: UInt32 { 60 }
}

public struct EthereumAddress: Address {
    private let raw: String
    
    public var string: String { raw }
    public var data: Data? { raw.hexData }
    
    public init(_ string: String) {
        self.raw = string.lowercased()
    }
    
    public init(publicKey: Data) {
        let data = publicKey.removingPrefixByte.keccak256.suffix(20)
        self.init(data.hexString)
    }
}

open class EthereumAccount<Address:ChainKit.Address>: AccountProtocol {
    
    public let privateKey: Data
    public let publicKey: Data
    public let logger: Logger
    
    open lazy var address: Address = Address(publicKey: self.publicKey)
    
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

extension EthereumAccount {
    
    
    public static func generatePublicKey(from privateKey: Data) throws -> Data {
        try DerivationUtil.generatePublicKey(privateKey: privateKey, compressed: false)
    }

    public static func displayPrivateKey(from privateKey: Data) -> String {
        privateKey.hexString
    }
    
    public static func importPrivateKey(_ key: String, keystorePassword _: String) throws -> Data {
        print(key)
        guard let data = key.hexData else {
            throw AccountError.invalidPrivateKeyFormat
        }
        return data
    }
}
