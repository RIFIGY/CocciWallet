//
//  web3.swift
//  Copyright © 2022 Argent Labs Limited. All rights reserved.
//

import Foundation

enum HexConversionError: Error {
    case invalidDigit
    case stringNotEven
}

extension Data {
    var hex: String {
        reduce("") {
            $0 + String(format: "%02x", $1)
        }
    }

    var hexString: String {
        "0x" + hex
    }

    init?(hex: String) {
        if let byteArray = try? HexUtil.byteArray(fromHex: hex.noHexPrefix) {
            self.init(bytes: byteArray, count: byteArray.count)
        } else {
            return nil
        }
    }
}

public extension String {
    
    var noHexPrefix: String {
        if self.hasPrefix("0x") {
            let index = self.index(self.startIndex, offsetBy: 2)
            return String(self[index...])
        }
        return self
    }
    
    var hexData: Data? {
        let noHexPrefix = self.noHexPrefix
        if let bytes = try? HexUtil.byteArray(fromHex: noHexPrefix) {
            return Data(bytes)
        }

        return nil
    }
}

class HexUtil {
    private static func convert(hexDigit digit: UnicodeScalar) throws -> UInt8 {
        switch digit {
        case UnicodeScalar(unicodeScalarLiteral: "0") ... UnicodeScalar(unicodeScalarLiteral: "9"):
            return UInt8(digit.value - UnicodeScalar(unicodeScalarLiteral: "0").value)

        case UnicodeScalar(unicodeScalarLiteral: "a") ... UnicodeScalar(unicodeScalarLiteral: "f"):
            return UInt8(digit.value - UnicodeScalar(unicodeScalarLiteral: "a").value + 0xa)

        case UnicodeScalar(unicodeScalarLiteral: "A") ... UnicodeScalar(unicodeScalarLiteral: "F"):
            return UInt8(digit.value - UnicodeScalar(unicodeScalarLiteral: "A").value + 0xa)

        default:
            throw HexConversionError.invalidDigit
        }
    }

    static func byteArray(fromHex string: String) throws -> [UInt8] {
        var iterator = string.unicodeScalars.makeIterator()
        var byteArray: [UInt8] = []

        while let msn = iterator.next() {
            if let lsn = iterator.next() {
                do {
                    let convertedMsn = try convert(hexDigit: msn)
                    let convertedLsn = try convert(hexDigit: lsn)
                    byteArray += [convertedMsn << 4 | convertedLsn]
                } catch {
                    throw error
                }
            } else {
                throw HexConversionError.stringNotEven
            }
        }
        return byteArray
    }
}
