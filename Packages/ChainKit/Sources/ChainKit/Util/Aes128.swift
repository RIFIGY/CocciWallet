//import tiny_aes
//import Foundation
//
//class Aes128Util {
//    var key: Data
//    var iv: Data?
//
//    init(key: Data, iv: Data? = nil) {
//        self.key = key
//        self.iv = iv
//    }
//
//    func xcrypt(input: Data) -> Data {
//        let ctx = UnsafeMutablePointer<AES_ctx>.allocate(capacity: 1)
//        defer {
//            ctx.deallocate()
//        }
//
//        let keyPtr = (key as NSData).bytes.assumingMemoryBound(to: UInt8.self)
//
//        if let iv = iv {
//            let ivPtr = (iv as NSData).bytes.assumingMemoryBound(to: UInt8.self)
//            AES_init_ctx_iv(ctx, keyPtr, ivPtr)
//        } else {
//            AES_init_ctx(ctx, keyPtr)
//        }
//
//        let inputPtr = (input as NSData).bytes.assumingMemoryBound(to: UInt8.self)
//        let length = input.count
//        let outputPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
//        defer {
//            outputPtr.deallocate()
//        }
//        outputPtr.update(from: inputPtr, count: length)
//
//        AES_CTR_xcrypt_buffer(ctx, outputPtr, UInt32(length))
//
//        return Data(bytes: outputPtr, count: length)
//    }
//}
import CryptoKit
import Foundation

class Aes128Util {
    private let key: SymmetricKey
    private var iv: Data
        
    init(key: Data, iv: Data? = nil) {
        self.key = SymmetricKey(data: key)
        self.iv = iv ?? Data.randomOfLength(12)!
    }
    
    func encrypt(input: Data) throws -> Data {
        let nonce = try AES.GCM.Nonce(data: iv)

        let sealedBox = try AES.GCM.seal(input, using: key, nonce: nonce)
        
        return iv + sealedBox.ciphertext + sealedBox.tag
    }
    
    func decrypt(input combined: Data, key: Data) throws -> Data {
        let key = SymmetricKey(data: key)

        let sealedBox = try AES.GCM.SealedBox(combined: combined)

        return try AES.GCM.open(sealedBox, using: key)

    }
}
