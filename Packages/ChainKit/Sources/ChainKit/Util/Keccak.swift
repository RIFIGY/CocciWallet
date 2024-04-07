////
////  web3.swift
////  Copyright © 2022 Argent Labs Limited. All rights reserved.
////
//
//import Foundation
//import tinykeccak
//
//public extension Data {
//    var keccak256: Data {
//        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 32)
//        defer {
//            result.deallocate()
//        }
//        let nsData = self as NSData
//        let input = nsData.bytes.bindMemory(to: UInt8.self, capacity: self.count)
//        keccak_256(result, 32, input, self.count)
//        return Data(bytes: result, count: 32)
//    }
//
//}
//
//public extension String {
//    
//    var keccak256: Data {
//        let data = self.data(using: .utf8) ?? Data()
//        return data.keccak256
//    }
//
//    var keccak256fromHex: Data {
//        let data = self.hexData!
//        return data.keccak256
//    }
//}
import Foundation
import CryptoSwift // Import CryptoSwift instead of tinykeccak

public extension Data {
    var keccak256: Data {
        // Directly use CryptoSwift's `keccak` function
        return self.sha3(.keccak256)
    }
}

public extension String {
    var keccak256: Data {
        guard let data = self.data(using: .utf8) else {
            return Data()
        }
        return data.keccak256
    }

    var keccak256fromHex: Data {
        guard let data = self.hexadecimal else {
            return Data()
        }
        return data.keccak256
    }
}

// Helper extension to convert a hex string to Data
extension String {
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)

        let lowerBound = startIndex
        var start = lowerBound
        while start < endIndex {
            let end = index(start, offsetBy: 2, limitedBy: endIndex) ?? endIndex
            let byteString = self[start..<end]
            if let num = UInt8(byteString, radix: 16) {
                data.append(num)
            } else {
                return nil
            }
            start = end
        }
        return data
    }
}
