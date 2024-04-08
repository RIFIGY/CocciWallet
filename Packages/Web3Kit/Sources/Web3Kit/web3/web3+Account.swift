//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import ChainKit
import web3
import Logging


extension web3.EthereumAddress: ChainKit.Address {
    public init(publicKey: Data) {
        let address = ChainKit.EthereumAddress.init(publicKey: publicKey)
        self.init(address.string)
    }
        
    public func data() -> Data? { asData() }
    public var string: String { asString() }
}



public class EthereumAccount: ChainKit.EthereumAccount<web3.EthereumAddress>, web3.EthereumAccountProtocol {

    
    public func sign(data: Data) throws -> Data {
        try KeyUtil.sign(message: data, with: privateKey, hashing: true)
    }

    public func sign(hex: String) throws -> Data {
        if let data = Data(hex: hex) {
            return try KeyUtil.sign(message: data, with: privateKey, hashing: true)
        } else {
            throw EthereumAccountError.signError
        }
    }

    public func sign(hash: String) throws -> Data {
        if let data = hash.web3.hexData {
            return try KeyUtil.sign(message: data, with: privateKey, hashing: false)
        } else {
            throw EthereumAccountError.signError
        }
    }

    public func sign(message: Data) throws -> Data {
        try KeyUtil.sign(message: message, with: privateKey, hashing: false)
    }

    public func sign(message: String) throws -> Data {
        if let data = message.data(using: .utf8) {
            return try KeyUtil.sign(message: data, with: privateKey, hashing: true)
        } else {
            throw EthereumAccountError.signError
        }
    }

    public func signMessage(message: Data) throws -> String {
        let prefix = "\u{19}Ethereum Signed Message:\n\(String(message.count))"
        guard var data = prefix.data(using: .ascii) else {
            throw EthereumAccountError.signError
        }
        data.append(message)
        let hash = data.web3.keccak256

        guard var signed = try? sign(message: hash) else {
            throw EthereumAccountError.signError
        }

        // Check last char (v)
        guard var last = signed.popLast() else {
            throw EthereumAccountError.signError
        }

        if last < 27 {
            last += 27
        }

        signed.append(last)
        return signed.web3.hexString
    }

    public func signMessage(message: TypedData) throws -> String {
        let hash = try message.signableHash()

        guard var signed = try? sign(message: hash) else {
            throw EthereumAccountError.signError
        }

        // Check last char (v)
        guard var last = signed.popLast() else {
            throw EthereumAccountError.signError
        }

        if last < 27 {
            last += 27
        }

        signed.append(last)
        return signed.web3.hexString
    }
}
