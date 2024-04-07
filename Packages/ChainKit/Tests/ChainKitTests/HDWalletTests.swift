import XCTest
@testable import ChainKit
@testable import HdWalletKit
import CryptoKit

final class HDWalletTests: XCTestCase {
    
    
    func testExample() {
        let words = try! Mnemonic.generate()
        let seed = Mnemonic.seed(mnemonic: words)!
        let hdWallet = HDWallet(seed: seed, coinType: 1, xPrivKey: HDExtendedKeyVersion.xprv.rawValue)

        _ = try! hdWallet.privateKey(account: 1, index: 1, chain: .external)

        XCTAssert(true, "Pass")
    }
    
    
//    func testAddressDerivation() {
//        let words = TestSeed.mnemonic.components(separatedBy: " ")
//        let bitcoinAddress = TestSeed.Bitcoin.address_0
//        let ethereumAddress = TestSeed.Ethereum.address_0
//        let seed = Mnemonic.seed(mnemonic: words)!
//        let coinTypes:[UInt32] = [0,60]
//        
//        
//        let hdWalletBtc = HDWallet(seed: seed, coinType: 0, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
//        let addressBtc = try! hdWalletBtc.address(coinType: 0, account: 0, index: 0, chain: .external)
//        
//        let hdWalletEth = HDWallet(seed: seed, coinType: 60, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
//        let addressEth = try! hdWalletEth.address(coinType: 60, account: 0, index: 0, chain: .external)
//
//
//        for coin in coinTypes {
//            let hdWallet = HDWallet(seed: seed, coinType: coin, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
//            let address = try! hdWallet.address(coinType: coin, account: 0, index: 0, chain: .external)
//            
//            if coin == 0 {
//                XCTAssertEqual(address.lowercased(), bitcoinAddress.lowercased(), "Excpted dervived Bitcoin address to be equal")
//            } else if coin == 60 {
//                XCTAssertEqual(address.lowercased(), ethereumAddress.lowercased(), "Excpted dervived Ethereum address to be equal")
//            }
//
//        }
//
//    }

    func testHashingPublicKey() {
        let publicKeyHex = "90f1289a490377e0153fe7d350be48ece321d584d29c269f402d1391cc117c44a63268b4b8ad4b677a372f8ff477ab7e83031117d85f104e50135fc45aa57918"
        let expectedAddress = "0x0160ec2fc8be8cbcf34e9d6a259b608e3e834525"
            
        let publicKeyData = Data(hex: publicKeyHex)!
        
        let publicKeyHash = publicKeyData.keccak256.suffix(20)
        let derivedAddress = publicKeyHash.hexString
        
        XCTAssertEqual(derivedAddress, expectedAddress, "Derived Ethereum address does not match the expected address")
    }
    

    
    func testHashingPrivateKey() {
        let words = "game lawn cigar main second toe question eagle pencil slush love problem"
        let derivationPath = "m/44'/60'/0'/0/0"
        let expectedPrivateKey = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
        let seed = Mnemonic.seed(mnemonic: words.components(separatedBy: " "))!

        let hdWallet = HDWallet(seed: seed, coinType: 60, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
        
        let privateKey = try! hdWallet.privateKey(path: derivationPath)

        let privateKeyHex = privateKey.raw.hexString
        
        XCTAssertEqual(privateKeyHex, expectedPrivateKey, "Derived Private key does not match expected hex string")
    }
    
    func testWalletHashing(){
        let words = "game lawn cigar main second toe question eagle pencil slush love problem"
        let expectedPrivateKey = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"

        let expectedAddress = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
        
        let seed = Mnemonic.seed(mnemonic: words.components(separatedBy: " "))!
        let hdWallet = HDWallet(seed: seed, coinType: 60, xPrivKey: HDExtendedKeyVersion.xprv.rawValue, purpose: .bip44)
        
        let privateKey = try! hdWallet.privateKey(account: 0, index: 0, chain: .external)

        let publicKey = privateKey.publicKey(compressed: false)

        let privateKeyHex = privateKey.raw.hexString
        let derivedAddress = publicKey.raw.removingPrefixByte.keccak256.suffix(20).hexString

        XCTAssertEqual(privateKeyHex.lowercased(), expectedPrivateKey.lowercased(), "Derived Private key 1 does not match expected hex string")
        XCTAssertEqual(derivedAddress.lowercased(), expectedAddress.lowercased(), "Derived Ethereum address does not match the expected address")
    }
    

}

