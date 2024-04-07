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

final class EthereumTests: XCTestCase {
    
    var hdWallet: HDWallet!
    var storage: TestMultipleKeyStorage!
    
    override func setUp() {
        let words = TestSeed.mnemonic.components(separatedBy: " ")
        let seed = Mnemonic.seed(mnemonic: words)!
        let hdWallet = HDWallet(seed: seed, coinType: 60, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
        self.hdWallet = hdWallet
        typealias testSeed = TestSeed.Ethereum
        self.storage = .init(keys: [
            (testSeed.private_key_0, testSeed.address_0),
            (testSeed.private_key_1, testSeed.address_1)
        ])
        super.setUp()
    }
    
    func testHdWalletPrivateKeyHashing() {

        let privateKeys: [String] = [
            TestSeed.Ethereum.private_key_0,
            TestSeed.Ethereum.private_key_1
        ]
                
        privateKeys.enumerated().forEach { index, key in
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            let hex = privateKey.raw.hexString
            
            XCTAssertEqual(hex.lowercased(), key.lowercased(), "Derived Private key Index \(index) does not match expected hex string")

        }
    }
    
    func testHdWalletAddressHashing(){
        let orderedAddresses = [
            TestSeed.Ethereum.address_0,
            TestSeed.Ethereum.address_1
        ]

        orderedAddresses.enumerated().forEach { index, address in
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            let publicKey = privateKey.publicKey(compressed: false)
            let derivedAddress = publicKey.raw.removingPrefixByte.keccak256.suffix(20).hexString
            XCTAssertEqual(derivedAddress.lowercased(), address.lowercased(), "Derived Ethereum address does not match the expected address")
        }
    }
    

    typealias EthereumAccount = ChainKit.EthereumAccount<EthereumAddress>
    func testImportEthereumAccount() {
        let privateKey = TestSeed.Ethereum.private_key_0
        let expectedAddress = TestSeed.Ethereum.address_0
        
        do {
            let account = try EthereumAccount.importAccount(into: storage, privateKey: privateKey, keystorePassword: "")
                        
            let expectedAddress = EthereumAddress(expectedAddress)

            XCTAssertEqual(account.address, expectedAddress, "Derived Ethereum address does not match the expected address")

        } catch {
            XCTFail("Expected Imported Ethereum Account \(error)")
        }

    }

}


