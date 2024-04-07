//
//  File.swift
//
//
//  Created by Michael on 4/4/24.
//

import Foundation
import XCTest
@testable import ChainKit
@testable import HdWalletKit
import CryptoKit

final class BitcoinTests: XCTestCase {
    var hdWallet: HDWallet!
    var storage: TestMultipleKeyStorage!
    
    override func setUp() {
        let words = TestSeed.mnemonic.components(separatedBy: " ")
        let seed = Mnemonic.seed(mnemonic: words)!
        let hdWallet = HDWallet(seed: seed, coinType: 0, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
        self.hdWallet = hdWallet
        typealias testSeed = TestSeed.Bitcoin
        self.storage = .init(keys: [
            (testSeed.private_key_0, testSeed.address_0),
            (testSeed.private_key_1, testSeed.address_1)
        ])
        super.setUp()
    }
    
    
    func testHdWalletPrivateKeyHashing() {

        let privateKeys: [String] = [
            TestSeed.Bitcoin.private_key_0,
            TestSeed.Bitcoin.private_key_1
        ]
                
        privateKeys.enumerated().forEach { index, expectedWIF in
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            var privateKeyData = privateKey.raw
            
            privateKeyData = Data([0x80]) + privateKeyData + Data([0x01])
            let privateKeyWIF = privateKeyData.encodeBase58Check // Encode to WIF format using the extension.

            XCTAssertEqual(privateKeyWIF.lowercased(), expectedWIF.lowercased(), "Derived Private key Index \(index) does not match expected hex string")
        }
    }

    
    func testHdWalletAddressHashing(){
        let orderedAddresses = [
            TestSeed.Bitcoin.address_0,
            TestSeed.Bitcoin.address_1
        ]

        orderedAddresses.enumerated().forEach { index, address in
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            let publicKeyData = privateKey.publicKey().raw
            
            let derivedAddress = (Data([0x00]) + publicKeyData.sha256.ripemd160).encodeBase58Check

            XCTAssertEqual(derivedAddress.lowercased(), address.lowercased(), "Derived Bitcoin address does not match the expected address")
        }
    }
    
    func testPrivateKeyHash(){
        let expectedWIF = TestSeed.Bitcoin.private_key_0
        do {
            let privateKeyData = try BitcoinAccount.importPrivateKey(expectedWIF, keystorePassword: "")
            
            let derivedData = Data([0x80]) + privateKeyData + Data([0x01])
            
            let privateKeyWIF = derivedData.encodeBase58Check

            XCTAssertEqual(privateKeyWIF.lowercased(), expectedWIF.lowercased(), "Derived Bitcoin WIF private key does not match expected WIF string.")
        } catch {
            XCTFail("Expected to generate a Private Key")
        }
    }
    
    
    func testPublicKeyHash(){
        let privateKey = TestSeed.Bitcoin.private_key_0
        let expectedPublicKey = TestSeed.Bitcoin.public_key_0
        
        do {
            let privateKeyData = try BitcoinAccount.importPrivateKey(privateKey, keystorePassword: "")
            let publicKeyData = try BitcoinAccount.generatePublicKey(from: privateKeyData)

            let publicKeyString = publicKeyData.hex

            XCTAssertEqual(publicKeyString.lowercased(), expectedPublicKey.lowercased(), "Derived Bitcoin WIF private key does not match expected WIF string.")
        } catch {
            XCTFail("Expected to generate a Private Key")
        }
    }
    
    func testAddressHash() {
        let privateKey = TestSeed.Bitcoin.private_key_0
        let expectedAddress = TestSeed.Bitcoin.address_0
        
        do {
            let privateKeyData = try BitcoinAccount.importPrivateKey(privateKey, keystorePassword: "")
            let publicKeyData = try BitcoinAccount.generatePublicKey(from: privateKeyData)
            
            let address = BitcoinAddress(publicKey: publicKeyData)
            let expectedAddress = BitcoinAddress(expectedAddress)
            XCTAssertEqual(address, expectedAddress, "Derived Ethereum address does not match the expected address")
            
        } catch {
            XCTFail("Expected account \(error)")
        }
    }
    
    func testImportBitcoinAccount() {
        let privateKey = TestSeed.Bitcoin.private_key_0
        let expectedAddress = TestSeed.Bitcoin.address_0
        
        do {
            let account = try BitcoinAccount.importAccount(into: storage, privateKey: privateKey, keystorePassword: "")
            let account1 = try BitcoinAccount(addressString: account.address.string, keyStorage: storage, keystorePassword: "")
            
            
            let expectedAddress = BitcoinAddress(expectedAddress)

            XCTAssertEqual(account.address, expectedAddress, "Derived Ethereum address does not match the expected address")
            XCTAssertEqual(account1.address, expectedAddress, "Derived Ethereum address does not match the expected address")


        } catch {
            XCTFail("Expected Imported Ethereum Account \(error)")
        }

    }

//    func testAddressHash() {
//        let storage = TestBitcoinultipleKeyStorage(privateKey: TestSeed.Bitcoin.private_key_0)
//        let expectedAddress = TestSeed.Bitcoin.address_0
//        let privateKey = TestSeed.Bitcoin.private_key_0
//
//        do {
//            let privateKeyData = try BitcoinAccount.importPrivateKey(fromWIF: privateKey)
//            let publicKeyData = try KeyUtil.generateSecp256k1(from: privateKeyData, compressed: true)
//            
//            let address = (Data([0x00]) + publicKeyData.sha256.ripemd160).encodeBase58Check
//            XCTAssertEqual(address.lowercased(), expectedAddress.lowercased(), "Derived Ethereum address does not match the expected address")
//
//        } catch {
//            XCTFail("Expected account \(error)")
//        }
//
//    }
//    
//    func testBitcoinAccount() {
//        let privateKey = TestSeed.Bitcoin.private_key_0
//        let storage = TestBitcoinultipleKeyStorage(privateKey: privateKey)
//        let expectedAddress = TestSeed.Bitcoin.address_0
//
//        do {
//            let account = try BitcoinAccount.importAccount(into: storage, privateKey: privateKey, keystorePassword: "")
//            let address = account.address
//            
//            XCTAssertEqual(address.string.lowercased(), expectedAddress.lowercased(), "Derived Ethereum address does not match the expected address")
//
//        } catch {
//            XCTFail("Expected account \(error)")
//        }
//    }

}

