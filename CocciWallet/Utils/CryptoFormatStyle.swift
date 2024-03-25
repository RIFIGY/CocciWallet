//
//  CryptoFormatStyle.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/25/24.
//

import SwiftUI
import Foundation
import BigInt

struct CryptoFormatStyle: FormatStyle {
    let decimals: UInt8
    let symbol: String?
//
    func format(_ value: BigUInt) -> String {
        let divisor = BigUInt(10).power(Int(decimals))
        let decimalValue = Double(value) / Double(divisor)
        return String(format: "%.\(decimals)f", decimalValue) + (symbol ?? "")
    }

}

extension FormatStyle where Self == CryptoFormatStyle {
    static func crypto(decimals: UInt8, symbol: String? = nil) -> CryptoFormatStyle {
        CryptoFormatStyle(decimals: decimals, symbol: symbol)
    }
}

struct SymbolFormatStyle: ParseableFormatStyle {
    let symbol: String
    typealias FormatInput = Double
    typealias FormatOutput = String
    typealias Strategy = NumberWithSymbolParseStrategy

    var parseStrategy: Strategy {
        NumberWithSymbolParseStrategy(symbol: symbol)
    }
    
    func format(_ value: Double) -> String {
        let string = value.formatted(.number.grouping(.automatic))
        return "\(string) \(symbol)"
    }
}

extension ParseableFormatStyle where Self == SymbolFormatStyle {
    static func symbol(_ symbol: String) -> SymbolFormatStyle {
        SymbolFormatStyle(symbol: symbol)
    }
}
extension FormatStyle where Self == SymbolFormatStyle {
    static func symbol(_ symbol: String) -> SymbolFormatStyle {
        SymbolFormatStyle(symbol: symbol)
    }
}

struct NumberWithSymbolParseStrategy: ParseStrategy {
    let symbol: String
    typealias ParseInput = String
    typealias ParseOutput = Double

    func parse(_ value: ParseInput) throws -> ParseOutput {
        // Attempt to remove the symbol and any extra spaces from the input string
        let trimmedValue = value
            .replacingOccurrences(of: symbol, with: "")
            .trimmingCharacters(in: .whitespaces)
        
        // Remove grouping separators based on the current locale
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: trimmedValue) {
            return number.doubleValue
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid number format"))
        }
    }
}

