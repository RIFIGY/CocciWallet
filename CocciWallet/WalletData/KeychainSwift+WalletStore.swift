//
//  KeychainSwift+EthereumStore.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/4/24.
//

import Foundation
import KeychainSwift
import ChainKit
import LocalAuthentication

extension KeychainSwift {
    
    static let shared = KeychainSwift()

    enum Error: Swift.Error {
        case access, decode, empty, hasKey
    }
}

extension KeychainSwift: PrivateKeyStorageProtocol {
    public func storePrivateKey<A>(key: Data, with address: A) throws where A : ChainKit.Address {
        guard getData(address.string) == nil else {
            throw Error.hasKey
        }
        self.set(key, forKey: address.string)
    }
    
    public func loadPrivateKey<A>(for address: A) throws -> Data where A : ChainKit.Address {
        guard let data = self.getData(address.string) else {
            throw Error.empty
        }
        return data
    }
    
    public func deletePrivateKey<A>(for address: A) throws where A : ChainKit.Address {
        self.delete(address.string)
    }
    
    public func fetchAccounts<A>(_ address: A.Type) throws -> [A] where A : ChainKit.Address {
        self.allKeys.map{ .init($0) }
    }
    
    public func deleteAllKeys<A>(_ address: A.Type) throws where A : ChainKit.Address {
        self.clear()
    }    
}

extension KeychainSwift {
    
    func fetchAccount<Account:ChainKit.AccountProtocol>(for address: Account.Address, password: String = "") async throws -> Account {
        guard try await Authentication.authenticate() else { throw Error.access }
        return try Account(
            addressString: address.string,
            keyStorage: self,
            keystorePassword: password,
            logger: nil
        )
    }
    
    func fetchPrivateKey<Address: ChainKit.Address>(for address: Address, password: String = "") async throws -> Data {
        guard try await Authentication.authenticate() else { throw Error.access }
        return try loadPrivateKey(for: address)
    }
    
    func removePrivateKey<Address: ChainKit.Address>(for address: Address, password: String = "") async throws {
        guard try await Authentication.authenticate() else { throw Error.access }
        try deletePrivateKey(for: address)
    }
    
    func clearKeys() async throws {
        guard try await Authentication.authenticate() else { throw Error.access }
        self.clear()
    }
    
}

class Authentication {
    
    static func authenticate(reason: String = "Authenticate to access sensitive data.") async throws -> Bool {
        #if !os(tvOS)
        let context = LAContext()
        var deviceError: NSError?
        var deviceBioError: NSError?

        
        let deviceOwner = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &deviceError)
        let deviceOwnerBio = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &deviceBioError)
        

        if deviceOwnerBio {
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        } else if deviceOwner {
            return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
        } else {
            if let deviceBioError {
                throw deviceBioError
            } else if let deviceError {
                throw deviceError
            } else {
                return false
            }
        }
        #else
        throw Error.noAuthentication
        #endif
    }
    
    enum Error: Swift.Error {
        case noAuthentication, didNotAuthenticate
    }
}
