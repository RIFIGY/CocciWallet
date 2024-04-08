//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import BigInt

public protocol NFTProtocol: Identifiable, Codable, Hashable, Equatable {
    var tokenId: BigUInt { get }
}
extension NFTProtocol {
//    static func ==(rh)
}



protocol OrdinalProtocol: NFTProtocol {
    var contract: String {get}
    var satoshi: BigUInt {get}
}


public struct Ordinal: OrdinalProtocol {
    public var id: String { contract + "_" + tokenId.description }
    public var tokenId: BigUInt { satoshi }
    public let satoshi: BigUInt
    public let contract: String
}



