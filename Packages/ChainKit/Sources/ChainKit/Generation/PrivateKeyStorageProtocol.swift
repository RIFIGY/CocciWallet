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


extension AccountProtocol {
        
    public static func create(into storage: any PrivateKeyStorageProtocol, keystorePassword password: String) throws -> Self {
        guard let privateKey = KeyUtil.generatePrivateKeyData() else {
            throw AccountError.createAccountError
        }
        do {
            let address = try storage.encryptAndStorePrivateKey(Self.self, key: privateKey, keystorePassword: password)
            return try .init(addressString: address.string, keyStorage: storage, keystorePassword: password, logger: nil)
        } catch {
            throw AccountError.createAccountError
        }
    }
    
    public static func importAccount(into storage: any PrivateKeyStorageProtocol, privateKey: String, keystorePassword password: String) throws -> Self {
        do {
            let privateKey = try Self.importPrivateKey(privateKey, keystorePassword: password)
            let address = try storage.encryptAndStorePrivateKey(Self.self, key: privateKey, keystorePassword: password)
            return try .init(addressString: address.string, keyStorage: storage, keystorePassword: password, logger: nil)
        } catch {
            throw AccountError.importAccountError
        }
    }
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
