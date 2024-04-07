//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation
import HdWalletKit



public class PrivateKeyGenerator<A:AccountProtocol> {
    public typealias Address = A.Address

    
    let storage: any PrivateKeyStorageProtocol
    
    public init(storage: any PrivateKeyStorageProtocol) {
        self.storage = storage
    }
    
    public func create(password: String) throws -> Address {
        let account = try A.create(into: storage, keystorePassword: password)
        return account.address
    }
    
    public func importWallet(_ privateKey: String, passsword: String) throws -> Address {
        let account = try A.importAccount(into: storage, privateKey: privateKey, keystorePassword: passsword)
        return account.address
    }
    
    
}

//class SeedGenerator {
//
//    typealias Addresses = [any ChainKit.Address]
//    typealias Coins = [ (any CoinType, any AccountProtocol.Type) ]
//
//    private static let defaultCoins:Coins = [ (Ethereum(), EthereumAccount<EthereumAddress>.self) ]
//    
//    func create(password: String, coins: Coins = defaultCoins) throws -> Addresses {
//        let words = try Mnemonic.generate()
//        guard let seed = Mnemonic.seed(mnemonic: words) else {
//            throw Error.mnemonicGeneration
//        }
//        
//        for path in coins {
//            let coin = path.0
//            let account = path.1
//            let wallet = HDWallet(seed: seed, coinType: coin.id, xPrivKey: HDExtendedKeyVersion.xprv.rawValue)
//            let publicKey = try wallet.publicKey(account: 0, index: 0, chain: .external)
//            let address: any ChainKit.Address = account.Address(publicKey: publicKey)
//        }
//
//    }
//    
//    func importWallet(_: String, passsword: String) throws -> Addresses {
//        []
//    }
//    
//    enum Error: Swift.Error {
//        case mnemonicGeneration
//    }
//    
//    
//}
