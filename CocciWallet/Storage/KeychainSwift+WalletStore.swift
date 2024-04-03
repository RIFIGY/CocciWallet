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

extension KeychainSwift {
    
    static let shared = KeychainSwift()

    enum Error: Swift.Error {
        case access, decode, empty, hasKey
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
