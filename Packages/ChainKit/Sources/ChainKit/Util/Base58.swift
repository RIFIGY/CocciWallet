//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import CryptoKit

extension Data {
    var sha256: Data {
        Data(SHA256.hash(data: self))
    }
    var encodeBase58Check: String {
        let checksum = sha256.sha256.prefix(4)
        let dataWithChecksum = self + checksum
        
        return dataWithChecksum.encodeBase58
    }
    
    var encodeBase58: String {
        Base58.encode(self)
    }
}

public extension String {
    var decodeBase58: Data {
        Base58.decode(self)
    }
    
    var decodeBase58Check: Data? {
        let fullData = self.decodeBase58
        guard fullData.count >= 4 else { return nil }

        let data = fullData.subdata(in: 0..<(fullData.count - 4))
        let checksum = fullData.subdata(in: (fullData.count - 4)..<fullData.count)

        let computedChecksum = data.sha256.sha256.prefix(4)
        guard computedChecksum == checksum else { return nil }

        return data
    }
}


public struct Base58 {
    static let baseAlphabets = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    static var zeroAlphabet: Character = "1"
    static var base: Int = 58

    static func sizeFromByte(size: Int) -> Int {
        size * 138 / 100 + 1
    }
    static func sizeFromBase(size: Int) -> Int {
        size * 733 / 1000 + 1
    }

    static func convertBytesToBase(_ bytes: Data) -> [UInt8] {
        var length = 0
        let size = sizeFromByte(size: bytes.count)
        var encodedBytes: [UInt8] = Array(repeating: 0, count: size)

        for b in bytes {
            var carry = Int(b)
            var i = 0
            for j in (0...encodedBytes.count - 1).reversed() where carry != 0 || i < length {
                carry += 256 * Int(encodedBytes[j])
                encodedBytes[j] = UInt8(carry % base)
                carry /= base
                i += 1
            }

            assert(carry == 0)

            length = i
        }

        var zerosToRemove = 0
        for b in encodedBytes {
            if b != 0 { break }
            zerosToRemove += 1
        }

        encodedBytes.removeFirst(zerosToRemove)
        return encodedBytes
    }

    public static func encode(_ bytes: Data) -> String {
        var bytes = bytes
        var zerosCount = 0

        for b in bytes {
            if b != 0 { break }
            zerosCount += 1
        }

        bytes.removeFirst(zerosCount)

        let encodedBytes = convertBytesToBase(bytes)

        var str = ""
        while 0 < zerosCount {
            str += String(zeroAlphabet)
            zerosCount -= 1
        }

        for b in encodedBytes {
            str += String(baseAlphabets[String.Index(utf16Offset: Int(b), in: baseAlphabets)])
        }

        return str
    }

    public static func decode(_ string: String) -> Data {
        guard !string.isEmpty else { return Data() }

        var zerosCount = 0
        var length = 0
        for c in string {
            if c != zeroAlphabet { break }
            zerosCount += 1
        }
        let size = sizeFromBase(size: string.lengthOfBytes(using: .utf8) - zerosCount)
        var decodedBytes: [UInt8] = Array(repeating: 0, count: size)
        for c in string {
            guard let baseIndex = baseAlphabets.firstIndex(of: c) else { return Data() }

            var carry = baseIndex.utf16Offset(in: baseAlphabets)
            var i = 0
            for j in (0...decodedBytes.count - 1).reversed() where carry != 0 || i < length {
                carry += base * Int(decodedBytes[j])
                decodedBytes[j] = UInt8(carry % 256)
                carry /= 256
                i += 1
            }

            assert(carry == 0)
            length = i
        }

        // skip leading zeros
        var zerosToRemove = 0

        for b in decodedBytes {
            if b != 0 { break }
            zerosToRemove += 1
        }
        decodedBytes.removeFirst(zerosToRemove)

        return Data(repeating: 0, count: zerosCount) + Data(decodedBytes)
    }
}

