// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import SwiftUI
import BigInt

enum ResourceError:Error {
    case none, decode
}

func JSON<D:Decodable>(_ type: D.Type = D.self, resource: String, with decoder: JSONDecoder = JSONDecoder()) throws -> D {
    guard let bundlePath = Bundle.module.url(forResource: resource, withExtension: "json") else {
        throw ResourceError.none
    }
    let data = try Data(contentsOf: bundlePath)
    let object = try decoder.decode(type, from: data)
    
    return object
}


//
//public struct CryptoFormatStyle: FormatStyle {
//    public let decimals: UInt8
//    public let precision: Int?
//    public let symbol: String?
//    
//    public func format(_ value: BigUInt) -> String {
//        let divisor = BigUInt(10).power(Int(decimals))
//        let decimalValue = Double(value) / Double(divisor)
//        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.usesGroupingSeparator = true
//        formatter.groupingSeparator = "," // Explicitly setting to comma, but usually determined by the locale
//        formatter.groupingSize = 3 // Grouping by thousands, which is the default
//        // Always use `precision` if specified, otherwise fall back to `decimals`.
//        // This will be the maximum number of decimal places to show.
//        formatter.maximumFractionDigits = precision ?? Int(decimals)
//        formatter.minimumFractionDigits = 0 // Don't force trailing zeros
//        
//        let formattedNumber = formatter.string(from: NSNumber(value: decimalValue)) ?? ""
//        return formattedNumber + (symbol ?? "")
//    }
//}
//
//public extension FormatStyle where Self == CryptoFormatStyle {
//    static func crypto(decimals: UInt8, precision: Int? = nil, symbol: String? = nil) -> CryptoFormatStyle {
//        CryptoFormatStyle(decimals: decimals, precision: precision, symbol: symbol)
//    }
//}
