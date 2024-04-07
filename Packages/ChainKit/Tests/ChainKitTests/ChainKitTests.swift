import XCTest
import CryptoKit
@testable import ChainKit
@testable import HdWalletKit

final class ChainKitTests: XCTestCase {

    


    
    func testEncryptAndDecrypt() {
        do {
            let expectedString = "Hello world!"
            let messageData = expectedString.data(using: .utf8)!
            let keyData = Data.randomOfLength(16)! // Generate a random 128-bit key.
            let key = SymmetricKey(data: keyData)
            
            // Encrypt
            let sealedBox = try AES.GCM.seal(messageData, using: key)
            // Generate combined data for transmission or storage.
            let combinedData = sealedBox.combined
            
            // Assuming combinedData is what you receive for decryption...
            
            // Decrypt
            // Initialize a SealedBox from the combined data.
            let receivedSealedBox = try AES.GCM.SealedBox(combined: combinedData!)
            // Decrypt the data using the same key.
            let decryptedData = try AES.GCM.open(receivedSealedBox, using: key)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            
            XCTAssertEqual(decryptedString, expectedString, "Decrypted string does not match original")
        } catch {
            XCTFail("Expected AES to succeed but encountered \(error)")
        }
    }
    
    func testEncryptAndDecryptWithNonce() {
        do {
            let expectedString = "Secure Message"
            let messageData = expectedString.data(using: .utf8)!
            
            // Generate a random 128-bit key.
            let keyData = Data.randomOfLength(16)!
            let key = SymmetricKey(data: keyData)
            
            // Generate a 12-byte nonce for AES-GCM.
            let nonceData = Data.randomOfLength(12)!
            guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
                XCTFail("Failed to create nonce")
                return
            }
            
            // Encrypt with the specified nonce
            let sealedBox = try AES.GCM.seal(messageData, using: key, nonce: nonce)
            
            // Assume we only have the ciphertext and the nonce (but not the SealedBox)
            // for decryption, e.g., received over a network or loaded from storage.
            // Thus, we create a combined data format manually: nonce + ciphertext + tag.
            let combinedDataForTransmission = nonceData + sealedBox.ciphertext + sealedBox.tag
            
            // Decrypting on the "receiving end" with the combined data format.
            // First, recreate the SealedBox from the combined format.
            let receivedSealedBox = try AES.GCM.SealedBox(combined: combinedDataForTransmission)
            
            // Then, decrypt using the key.
            let decryptedData = try AES.GCM.open(receivedSealedBox, using: key)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            
            XCTAssertEqual(decryptedString, expectedString, "Decrypted string does not match the original message")
        } catch {
            XCTFail("Expected AES encryption/decryption to succeed but encountered \(error)")
        }
    }

    
    func testAES(){
        do {
            let expectedString = "Hello world!"
            let message = expectedString.data(using: .utf8)!
            let iv = Data.randomOfLength(12)!
            let key = Data.randomOfLength(16)!
            
            let encrypter = Aes128Util(key: key, iv: iv)
            let encryptedData = try encrypter.encrypt(input: message)
            
            let decrypter = Aes128Util(key: key, iv: iv)
            let decryptedData = try decrypter.decrypt(input: encryptedData, key: key)
            let decryptedString = String(data: decryptedData, encoding: .utf8)

            
            XCTAssertEqual(decryptedString, expectedString, "Decrypted string does not match original")
        } catch {
            XCTFail("Expected AES to succeed but encountered \(error)")
        }

    }
    
}
