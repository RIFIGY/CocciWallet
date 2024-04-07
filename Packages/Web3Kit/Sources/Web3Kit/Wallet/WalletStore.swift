

import Foundation
import web3


public protocol WalletStore: EthereumMultipleKeyStorageProtocol {
    
//    associatedtype W : Identifiable
    
    func deleteAllAddresses() throws
    func deletePrivateKey(address: String) throws
    func fetchAddresses() throws -> [String]
    func loadPrivateKey(address: String) throws -> Data
    func storePrivateKey(key: Data, address: String) throws
}
//
public extension WalletStore {
    func deleteAllKeys() throws {
        try deleteAllAddresses()
    }
    func deletePrivateKey(for address: EthereumAddress) throws {
        try deletePrivateKey(address: address.asString())
    }
    func fetchAccounts() throws -> [EthereumAddress] {
        try fetchAddresses().map{ .init($0) }
    }
    func loadPrivateKey(for address: EthereumAddress) throws -> Data {
        try loadPrivateKey(address: address.asString() )
    }
    func storePrivateKey(key: Data, with address: EthereumAddress) throws {
        try storePrivateKey(key: key, address: address.asString())
    }
}






//public extension WalletStore where Wallet.ID == String {
//
//    func deletePrivateKey(address: Wallet.ID) throws {
//        try self.deletePrivateKey(for: EthereumAddress(address) )
//    }
//
//    func fetchAddresses() throws -> [Wallet.ID] {
//        let addresses:[EthereumAddress] = try self.fetchAccounts()
//        return addresses.map{ $0.asString() }
//    }
//
//    func loadPrivateKey(address: Wallet.ID) throws -> Data {
//        try loadPrivateKey(for: EthereumAddress(address))
//    }
//
//    func storePrivateKey(key: Data, address: Wallet.ID) throws {
//        try storePrivateKey(key: key, with: EthereumAddress(address))
//    }
//}
//
//public extension WalletStore {
//
//    func deletePrivateKey(wallet: Wallet) throws {
//        try self.deletePrivateKey(for: EthereumAddress(wallet.address) )
//    }
//
//    func loadPrivateKey(wallet: Wallet) throws -> Data {
//        try loadPrivateKey(for: EthereumAddress(wallet.address) )
//    }
//
//    func storePrivateKey(key: Data, wallet: Wallet) throws {
//        try storePrivateKey(key: key, with: EthereumAddress(wallet.address))
//    }
//}
