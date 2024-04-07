//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/27/24.
//

import Foundation

public protocol PrivateKeyStorageProtocol {
    
    func deleteAllKeys<A:Address>(_ address: A.Type) throws
    func fetchAccounts<A:Address>(_ address: A.Type) throws -> [A]
    func deletePrivateKey<A:Address>(for _: A) throws
    func loadPrivateKey<A:Address>(for _: A) throws -> Data
    func storePrivateKey<A:Address>(key: Data, with _: A) throws
}

public extension PrivateKeyStorageProtocol {
    func encryptAndStorePrivateKey<A:AccountProtocol>(_ account: A.Type, key: Data, keystorePassword: String) throws -> A.Address {
        let encodedKey = try KeystoreUtil.encode(account, privateKey: key, password: keystorePassword)
        let publicKey = try A.generatePublicKey(from: key)
        let address = A.Address(publicKey: publicKey)
        try storePrivateKey(key: encodedKey, with: address)
        return address
    }

    func loadAndDecryptPrivateKey<A:Address>(for address: A, keystorePassword: String) throws -> Data {
        let encryptedKey = try loadPrivateKey(for: address)
        return try KeystoreUtil.decode(A.self, data: encryptedKey, password: keystorePassword)
    }
}
