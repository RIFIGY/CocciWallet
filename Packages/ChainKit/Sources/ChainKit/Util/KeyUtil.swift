//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import Logging
import secp256k1


public class KeyUtil {
    internal static var logger: Logger {
        Logger(label: "chainkit.key-util")
    }

    public static func generatePrivateKeyData() -> Data? {
        Data.randomOfLength(32)
    }
    
    public static func encodeWIF(data: Data, prefix: UInt8, suffix: UInt8 = 0x01) -> Data {
        Data([prefix]) + data + Data([suffix])
    }
    
    public static func stringWIF(privateKey: Data, prefix: UInt8, suffix: UInt8 = 0x01) -> String {
        let encoded = encodeWIF(data: privateKey, prefix: prefix, suffix: suffix)
        return encoded.encodeBase58Check
    }
    

}

extension Data {
    static func randomOfLength(_ length: Int) -> Data? {
        Data((0 ..< length).map { _ in UInt8.random(in: UInt8.min ... UInt8.max) })
    }
    
    var removingPrefixByte: Data {
        guard !self.isEmpty else { return self }
        return self.subdata(in: 1..<self.count)
    }
}
