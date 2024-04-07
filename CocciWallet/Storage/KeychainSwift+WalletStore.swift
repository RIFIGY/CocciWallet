//
//  KeychainSwift+EthereumStore.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/4/24.
//

import Foundation
import KeychainSwift
import Web3Kit
import OffChainKit
import ChainKit

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

extension KeychainSwift: WalletStore {
    public func deleteAllAddresses() throws {
        self.clear()
    }
    
    public func deletePrivateKey(address: String) throws {
        self.delete(address)
    }
    
    public func fetchAddresses() throws -> [String] {
        self.allKeys
    }
    
    public func loadPrivateKey(address: String) throws -> Data {
        guard let data = self.getData(address) else {
            throw Error.empty
        }
        return data
    }
    
    public func storePrivateKey(key: Data, address: String) throws {
        guard getData(address) == nil else {
            throw Error.hasKey
        }
        self.set(key, forKey: address)
    }
    
}
