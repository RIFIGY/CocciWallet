//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import Logging


public protocol AccountProtocol {
    associatedtype Address : ChainKit.Address
    var address: Address {get}
    
    static func importPrivateKey(_ _: String, keystorePassword _: String) throws -> Data
    static func displayPrivateKey(from _: Data) -> String
    static func generatePublicKey(from _: Data) throws -> Data
    
//    init(privateKey: Data, logger: Logger?) throws
    init(addressString: String, keyStorage: any PrivateKeyStorageProtocol, keystorePassword password: String, logger: Logging.Logger?) throws

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



public enum AccountError: Error {
    case createAccountError
    case importAccountError
    case existingAccountError
    case loadAccountError
    case signError
    case invalidPrivateKeyFormat
}
