//
//  SwiftUIView.swift
//  
//
//  Created by Michael on 4/13/24.
//

import SwiftUI
import BigInt

struct CryptoFormatStyle: FormatStyle {
    let decimals: UInt8
    let precision: Int?
    let symbol: String?
    
    func format(_ value: BigUInt) -> String {
        let divisor = BigUInt(10).power(Int(decimals))
        let decimalValue = Double(value) / Double(divisor)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "," // Explicitly setting to comma, but usually determined by the locale
        formatter.groupingSize = 3 // Grouping by thousands, which is the default
        // Always use `precision` if specified, otherwise fall back to `decimals`.
        // This will be the maximum number of decimal places to show.
        formatter.maximumFractionDigits = precision ?? Int(decimals)
        formatter.minimumFractionDigits = 0 // Don't force trailing zeros
        
        let formattedNumber = formatter.string(from: NSNumber(value: decimalValue)) ?? ""
        return formattedNumber + (symbol ?? "")
    }
}

extension FormatStyle where Self == CryptoFormatStyle {
    static func crypto(decimals: UInt8, precision: Int? = nil, symbol: String? = nil) -> CryptoFormatStyle {
        CryptoFormatStyle(decimals: decimals, precision: precision, symbol: symbol)
    }
}
