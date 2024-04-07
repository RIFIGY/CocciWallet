////
////  File.swift
////
////
////  Created by Michael on 4/4/24.
////
//
//import Foundation
//import XCTest
//@testable import ChainKit
////@testable import HdWalletKit
//import Foundation
//import XCTest
//@testable import ChainKit
//@testable import HdWalletKit
//
//final class SolanaTests: XCTestCase {
//    
//    var hdWallet: HDWallet!
//    
//    override func setUp() {
//        let words = TestSeed.solanaMnemonic.components(separatedBy: " ")
//        let seed = Mnemonic.seed(mnemonic: words)!
//        let hdWallet = HDWallet(seed: seed, coinType: 501, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
//        self.hdWallet = hdWallet
//
//        super.setUp()
//    }
//    
//    func testPrivateKeyToSolanaAddress() {
//        let expectedPrivateKey = "36LMFD8uMjFnXGwHPZuYBMZq82qhubL887JbhYYvLHiyqGzYjMGbaXTfcC3t6mgnn15SCQ8mZmUhWQ6FLYMs9yTJ"
//        let expectedAddress = "CoaaJFV6zqUcixGGPL5ufwAHwVC85q7RAxttDM34ezpL"
//
//        let privateKeyData = expectedPrivateKey.decodeBase58
//        XCTAssertEqual(privateKeyData.count, 64, "Invalid private key length")
//        
//        let publicKeyData = privateKeyData.suffix(32)
//        let solanaAddress = publicKeyData.encodeBase58
//        
//        XCTAssertEqual(solanaAddress.lowercased(), expectedAddress.lowercased(), "Derived Solana address does not match expected address")
//    }
//        
//
//    func testEthereumPrivateKey() {
//        let words = TestSeed.solanaMnemonic.components(separatedBy: " ")
//        let seed = Mnemonic.seed(mnemonic: words)!
//        let hdWallet = HDWallet(seed: seed, coinType: 60, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
//
//        // Derive the Ethereum private key using the specified path
//        let privateKey = try! hdWallet.privateKey(account: 0, index: 1, chain: .external)
//        let hex = privateKey.raw.toHexString
//
//        let expectedKey = "0x8f337acb395707baec68b4bbbf9458be0311d332aa34bcec100380fcb023c26e"
//        XCTAssertEqual(hex.lowercased(), expectedKey.lowercased(), "Expected Ethereum private key at Account 0, Index 0 does not match")
//    }
//    func testSolanaPrivateKeyToAddress() {
//        let words = TestSeed.solanaMnemonic.components(separatedBy: " ")
//        let seed = Mnemonic.seed(mnemonic: words)!
//        let hdWallet = HDWallet(seed: seed, coinType: 501, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
//        let expectedPrivateKey = "36LMFD8uMjFnXGwHPZuYBMZq82qhubL887JbhYYvLHiyqGzYjMGbaXTfcC3t6mgnn15SCQ8mZmUhWQ6FLYMs9yTJ"
//        
//        let privateKeyData = expectedPrivateKey.decodeBase58.prefix(32)
//
//        let privateKey = try! hdWallet.privateKey(account: 0)
//        let publicKey = try! privateKey.derived(at: 1, hardened: true, curve: .ed25519)
//        
//        print(privateKey.raw.encodeBase58)
//        print(privateKeyData.encodeBase58)
//        
//        let solanaAddress = publicKey.raw.encodeBase58
//
//        let expectedAddress = "CoaaJFV6zqUcixGGPL5ufwAHwVC85q7RAxttDM34ezpL"
//        XCTAssertEqual(solanaAddress.lowercased(), expectedAddress.lowercased(), "Derived Solana address does not match expected address")
//    }
//    
////    func testHdWalletPrivateKeyHashing() {
////
////        let privateKeys: [String] = [
////            TestSeed.Solana.private_key_0,
////            TestSeed.Solana.private_key_1
////        ]
////                
////        privateKeys.enumerated().forEach { index, key in
////            let privateKey = try! hdWallet.privateKey(account: 0, index: index, chain: .external)
////            let hex = privateKey.raw.encodeBase58
////            
////            XCTAssertEqual(hex.lowercased(), key.lowercased(), "Derived Private key Index \(index) does not match expected hex string")
////
////        }
////    }
//}
//    
//  
