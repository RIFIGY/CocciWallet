//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation

public protocol WIFAccount: AccountProtocol where Address: WIFAddress {
    static var prefix: UInt8 { get }
}


extension WIFAccount {
    
    public static func displayPrivateKey(from privateKey: Data) -> String {
        KeyUtil.stringWIF(privateKey: privateKey, prefix: Self.prefix)
        
    }
    
    public static func importPrivateKey(_ key: String, keystorePassword password: String) throws -> Data {
        if let wifData = try? importPrivateKey(wif: key, keystorePassword: password, prefixByte: Self.prefix) {
            return wifData
        }
        
        if let hexData = Data(hex: key), !hexData.isEmpty {
            return hexData
        }
        throw AccountError.invalidPrivateKeyFormat
    }
    
    public static func generatePublicKey(from privateKey: Data) throws -> Data {
        try DerivationUtil.generatePublicKey(privateKey: privateKey, compressed: true)
    }
    

    private static func importPrivateKey(wif key: String, keystorePassword password: String, prefixByte: UInt8) throws -> Data {
        guard let decodedData = key.decodeBase58Check,
              (decodedData.count == 33 || decodedData.count == 34)
        else {
            throw AccountError.invalidPrivateKeyFormat
        }
        
        if decodedData.first == prefixByte {
            return decodedData.subdata(in: 1..<33)
        } else {
            throw AccountError.invalidPrivateKeyFormat
        }
    }
}
