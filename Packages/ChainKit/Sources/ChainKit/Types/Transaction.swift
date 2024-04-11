//
//  File.swift
//  
//
//  Created by Michael on 4/8/24.
//

import Foundation
import BigInt

public protocol TransactionProtocol: Identifiable, Hashable {
    associatedtype Sorter : Equatable, Comparable
    var sorter: Sorter {get}
    associatedtype Address : ChainKit.Address
    var title: String { get }
    var subtitle: String {get}
    var bigValue: BigUInt? {get}
    var timestamp: Date? {get}
    
    var to: Address {get}
    var from: Address {get}
}

extension TransactionProtocol {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}


public extension TransactionProtocol {
    var amount: Double? {nil}
}
