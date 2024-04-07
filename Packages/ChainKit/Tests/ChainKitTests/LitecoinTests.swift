//
//  File.swift
//  
//
//  Created by Michael on 4/6/24.
//

import Foundation
import XCTest
@testable import ChainKit
@testable import HdWalletKit
import CryptoKit

final class LitecoinTests: XCTestCase {
    var hdWallet: HDWallet!
    typealias Litecoin = TestSeed.Litecoin
    
    static let private_key_0 = "T4TGMZdJCqoHUu1QYfKAYJtTqA9jttTyxPsxsE5JtVhJ1giMGkch"
    static let public_key_0 = "03b8e2c335a7eabda621388c8261b1f86c3775e1dbbd630cedacc3ac79d966a0ae"
    static let address_0 = "La425FmwtVyyKXRM469k9AtjTG7PgfxRjJ"
    
    override func setUp() {
        let words = TestSeed.mnemonic.components(separatedBy: " ")
        let seed = Mnemonic.seed(mnemonic: words)!
        let hdWallet = HDWallet(seed: seed, coinType: 2, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
        self.hdWallet = hdWallet
        super.setUp()
    }
    
    
    func testHdWalletPrivateKeyHashing() {

        let privateKeys: [String] = [
            Litecoin.private_key_0,
            Litecoin.private_key_1
        ]
                
        privateKeys.enumerated().forEach { index, expectedWIF in
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            let privateKeyData = privateKey.raw
            let wifString = KeyUtil.stringWIF(privateKey: privateKeyData, prefix: 0xb0)

            XCTAssertEqual(wifString.lowercased(), expectedWIF.lowercased(), "Derived Private key Index \(index) does not match expected string")
        }
    }
    
    func testHdWalletPublicKeyHashing() {

        let publicKeys: [String] = [
            Litecoin.public_key_0,
            Litecoin.public_key_1
        ]
        
                
        publicKeys.enumerated().forEach { index, expectedPublicKey in
            
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            
            let publicKeyData = try! DerivationUtil.generatePublicKey(privateKey: privateKey.raw, compressed: true)
            let publicKeyString = publicKeyData.hex

            XCTAssertEqual(publicKeyString.lowercased(), expectedPublicKey.lowercased(), "Derived Public key Index \(index) does not match expected hex string")
        }
    }
    
    func testHdWalletAddressKeyHashing() {

        let addresses: [String] = [
            Litecoin.address_0,
            Litecoin.address_1
        ]
        
                
        addresses.enumerated().forEach { index, expectedAddress in
            
            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
            
            let publicKeyData = try! DerivationUtil.generatePublicKey(privateKey: privateKey.raw, compressed: true)

            let hash = publicKeyData.sha256.ripemd160
            let data = Data([0x30]) + hash
            let address = data.encodeBase58Check
            
            XCTAssertEqual(address.lowercased(), expectedAddress.lowercased(), "Derived Public key Index \(index) does not match expected hex string")
        }
    }

}
