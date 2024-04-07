//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
@testable import ChainKit

class TestMultipleKeyStorage: PrivateKeyStorageProtocol {

    
    private var key: (privateKey: String, address: String)
    
    private var keys: [(privateKey: String, address: String)]
    
    
    init(keys: [(String,String)]) {
        self.keys = keys
        self.key = keys.first!
    }
    
    init(privateKey: String, address: String) {
        self.key = (privateKey, address)
        self.keys = [(privateKey, address)]
        
    }
    
    func loadPrivateKey<A:Address>(for address: A) throws -> Data {
        guard let key = keys.first(where: {$0.address.lowercased() == address.string.lowercased()} ) else {
            throw AccountError.loadAccountError
        }
        var account: (any AccountProtocol.Type)? {
            switch A.self {
            case is EthereumAddress.Type:
                return EthereumAccount<EthereumAddress>.self
            case is BitcoinAddress.Type:
                return BitcoinAccount.self
            case is LitecoinAddress.Type:
                return LitecoinAccount.self
            case is DogecoinAddress.Type:
                return DogecoinAccount.self
            case is SolanaAddress.Type:
                return SolanaAccount.self

            default: return nil
            }
        }
        guard let account else {return Data()}
        let privateKey = try account.importPrivateKey(key.privateKey, keystorePassword: "")
        return try KeystoreUtil.encode(account, privateKey: privateKey, password: "")

    }
    
    
    func storePrivateKey<A:Address>(key: Data, with _: A) throws {
//        self.privateKeys.append(key)
    }
    
    func fetchAccounts<A>(_ address: A.Type) throws -> [A] where A : ChainKit.Address {
        keys.map{ .init($0.address) }
    }
    
    func deletePrivateKey<A>(for _: A) throws where A : ChainKit.Address {
        
    }
        

    func deleteAllKeys<A>(_ address: A.Type) throws where A : ChainKit.Address {
        
    }

}
