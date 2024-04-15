//
//  BigUInt+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import Foundation
import BigInt

extension BigUInt {
    
    static var weiToEtherDivisor: BigUInt {
        BigUInt(10).power(18)
    }
    
    
    var eth: Double {
        let balanceInWei = Decimal(string: self.description) ?? Decimal.zero
        let divisor = Decimal(string: Self.weiToEtherDivisor.description)!
        
        let balanceInEtherDecimal = balanceInWei / divisor
        
        return NSDecimalNumber(decimal: balanceInEtherDecimal).doubleValue
    }
    
    func value(decimals: UInt8) -> Double {
        let balanceInWei = Decimal(string: self.description) ?? Decimal.zero
        let weiToTokenDivisor: BigUInt = BigUInt(10).power(Int(decimals))
        let divisor = Decimal(string: weiToTokenDivisor.description)!

        let balanceInTokenDecimal = balanceInWei / divisor
        return NSDecimalNumber(decimal: balanceInTokenDecimal).doubleValue
    }
    
    func ethString(decimals: UInt8 = 2) -> String {
        let decimals = (decimals <= 18 && decimals > 0) ? decimals : 2
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = Int(decimals)
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: eth))!
    }
    
    func double(_ decimals: UInt8) -> Double {
        let divisor = BigUInt(10).power(Int(decimals))
        return Double(self) / Double(divisor)
    }
    
    
}

extension Double {
    func string(decimals: Int = 5) -> String {
        let decimals = decimals <= 18 ? decimals : 18
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimals
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: self))!

    }
    
    func bigValue(decimals: UInt8 = 18) -> BigUInt {
        let decimalMultiplier = BigUInt(10).power(Int(decimals))
        return BigUInt(self * Double(decimalMultiplier))
    }
}
