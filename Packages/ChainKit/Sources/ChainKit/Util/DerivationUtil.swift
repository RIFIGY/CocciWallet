//
//  File.swift
//  
//
//  Created by Michael on 4/6/24.
//

import Foundation
import CryptoKit
import Logging
import secp256k1

enum Algo {
    case secp256k1, ed25519
}

public enum DerivationError: Error {
    case invalidContext
    case privateKeyInvalid
    case unknownError
    case signatureFailure
    case signatureParseFailure
    case badArguments
}

struct DerivationUtil {
    internal static var logger: Logger {
        Logger(label: "chainkit.derivation-util")
    }
    
    public static func generatePublicKey(privateKey: Data, curve: Algo = .secp256k1, compressed: Bool = true) throws -> Data {
        switch curve {
        case .secp256k1:
            try generateSecp256k1(from: privateKey, compressed: compressed)
        case .ed25519:
            try generateEd25519(from: privateKey, compressed: compressed)
        }
    }
    
    public static func generateEd25519(from privateKey: Data, compressed: Bool) throws -> Data {
        
        guard privateKey.count == 32 else {
            throw NSError(domain: "SolanaAccountError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid private key length for Ed25519."])
        }
        
        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKey)
        
        let publicKey = privateKey.publicKey
        
        return publicKey.rawRepresentation
    }
    
    static func generateSecp256k1(from privateKey: Data, compressed: Bool) throws -> Data {
        guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)) else {
            logger.warning("Failed to generate a public key: invalid context.")
            throw DerivationError.invalidContext
        }

        defer {
            secp256k1_context_destroy(ctx)
        }

        let privateKeyPtr = (privateKey as NSData).bytes.assumingMemoryBound(to: UInt8.self)
        guard secp256k1_ec_seckey_verify(ctx, privateKeyPtr) == 1 else {
            logger.warning("Failed to generate a public key: private key is not valid.")
            throw DerivationError.privateKeyInvalid
        }

        let publicKeyPtr = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        defer {
            publicKeyPtr.deallocate()
        }
        guard secp256k1_ec_pubkey_create(ctx, publicKeyPtr, privateKeyPtr) == 1 else {
            logger.warning("Failed to generate a public key: public key could not be created.")
            throw DerivationError.unknownError
        }

        // Determine the correct length for compressed vs uncompressed.
        var outputLength: size_t = compressed ? 33 : 65
        var outputBuffer = [UInt8](repeating: 0, count: outputLength)
        guard secp256k1_ec_pubkey_serialize(ctx, &outputBuffer, &outputLength, publicKeyPtr, compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)) == 1 else {
            logger.warning("Failed to serialize public key.")
            throw DerivationError.unknownError
        }

        return Data(bytes: outputBuffer, count: outputLength)
    }
    


}
