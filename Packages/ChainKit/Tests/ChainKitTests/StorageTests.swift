//
//  File.swift
//  
//
//  Created by Michael on 4/6/24.
//

import Foundation
import Foundation
import XCTest
@testable import ChainKit

final class StorageTests: XCTestCase {
    let storage = TestMultipleKeyStorage(keys: TestSeed.addresses)
    
    func testStorage() {
        let types:[any AccountProtocol.Type] = [
            BitcoinAccount.self,
            EthereumAccount<EthereumAddress>.self,
            LitecoinAccount.self,
            DogecoinAccount.self,
        ]
        
        for account in types {
            testPrivateKeyHash(account: account)
            testPublicKeyHash(account: account)
            testAddressHash(account: account)
            testImport(account: account)
        }
        
    }

    func testPrivateKeyHash<Account:AccountProtocol>(account: Account.Type) {
        let keys = TestSeed.key(Account.Address.self)
        let expectedPrivateKey = keys.privateKey
        
        do {
            let privateKeyData = try Account.importPrivateKey(expectedPrivateKey, keystorePassword: "")
            let privateKeyString = Account.displayPrivateKey(from: privateKeyData)
                        
            XCTAssertEqual(privateKeyString.lowercased(), expectedPrivateKey.lowercased(), "Derived Private Key does not match expected Private Key string.")

        } catch {
            XCTFail("Expected Private Key hash for \(account.self)")
        }
        
    }
    
    func testPublicKeyHash<Account:AccountProtocol>(account: Account.Type) {
        let keys = TestSeed.key(Account.Address.self)
        let privateKeyString = keys.privateKey
        let expectedPublicKey = keys.publicKey
        
        guard !expectedPublicKey.isEmpty else { XCTAssert(true); return }
        
        do {
            let privateKeyData = try Account.importPrivateKey(privateKeyString, keystorePassword: "")
            let publicKeyData = try Account.generatePublicKey(from: privateKeyData)
            
            let publicKeyString = publicKeyData.hex
            
            XCTAssertEqual(publicKeyString.lowercased(), expectedPublicKey.lowercased(), "Derived Private Key does not match expected Private Key string.")

        } catch {
            XCTFail("")
        }
        
    }
    
    func testAddressHash<Account:AccountProtocol>(account: Account.Type) {
        typealias Address = Account.Address
        let keys = TestSeed.key(Address.self)
        let privateKey = keys.privateKey
        let expectedAddress = keys.address
        
        do {
            let privateKeyData = try Account.importPrivateKey(privateKey, keystorePassword: "")
            let publicKeyData = try Account.generatePublicKey(from: privateKeyData)
            
            let address = Address(publicKey: publicKeyData)
            let expectedAddress = Address(expectedAddress)
            XCTAssertEqual(address, expectedAddress, "Derived Ethereum address does not match the expected address")
            
        } catch {
            XCTFail("Expected account \(error)")
        }
    }
    
    func testImport<Account:AccountProtocol>(account: Account.Type) {
        typealias Address = Account.Address

        let keys = TestSeed.key(Address.self)

        let privateKey = keys.privateKey
        let expectedAddress = keys.address
        
        do {
            let account = try Account.importAccount(into: storage, privateKey: privateKey, keystorePassword: "")
                        
            let expectedAddress = Address(expectedAddress)

            XCTAssertEqual(account.address, expectedAddress, "Derived Ethereum address does not match the expected address")

        } catch {
            XCTFail("Expected Imported Ethereum Account \(error)")
        }
    }
    
//    private func keys<A:Address>(_ type: A.Type) -> [Keys] {
//        if type == EthereumAddress.self {
//            return [
//                (ethereum.private_key_0, "", ethereum.address_0),
//                (ethereum.private_key_1, "", ethereum.address_1)
//            ]
//        } else if type == BitcoinAddress.self {
//            return [
//                (bitcoin.private_key_0, bitcoin.public_key_0, bitcoin.address_0),
//                (bitcoin.private_key_1, bitcoin.public_key_1, bitcoin.address_1)
//            ]
//        } else {
//            return []
//        }
//    }
//    
//    private func key<A:Address>(_ type: A.Type) -> Keys {
//        if type == EthereumAddress.self {
//            (ethereum.private_key_0, "", ethereum.address_0)
//        } else if type == BitcoinAddress.self {
//            (bitcoin.private_key_0, bitcoin.public_key_0, bitcoin.address_0)
//        } else {
//            ("","","")
//        }
//    }
    
}
