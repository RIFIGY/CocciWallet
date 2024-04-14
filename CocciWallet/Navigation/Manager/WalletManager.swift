//
//  WalletHollder.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation
import Web3Kit
import KeychainSwift
//import web3
import OffChainKit
import ChainKit
import WalletData


extension Wallet {
    
    
}


//@Observable
//class WalletHolder {
//    private let store = KeychainSwift.shared
//    typealias EthereumAccount = Web3Kit.EthereumAccount
//    
//    func getAccount<A:Address>(for address: A, password: String = "") async throws -> EthereumAccount {
//        guard try await Authentication.authenticate() else {
//            throw Authentication.Error.didNotAuthenticate
//        }
//        let account = try EthereumAccount(addressString: address.string, keyStorage: store, keystorePassword: password)
//        return account
//    }
//    
//    func getPrivateKey<A:Address>(for address: A, password: String = "") async throws -> Data {
//        guard try await Authentication.authenticate() else {
//            throw Authentication.Error.didNotAuthenticate
//        }
//        return try store.loadPrivateKey(for: address)
//    }
//    
//    fileprivate func deletePrivateKey<A:Address>(for address: A) async throws {
//        guard try await Authentication.authenticate() else {return}
//        try store.deletePrivateKey(for: address)
//    }
//    
//}
