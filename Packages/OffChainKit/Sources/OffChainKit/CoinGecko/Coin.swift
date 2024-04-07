//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/25/24.
//

import Foundation


public extension CoinGecko {
    
    struct Coin: Identifiable, Codable {
        public let id: String
        public let symbol: String
        public let name: String
        public var platforms: [String : String]? // platformID : contractAddress
        public var market_data: MarketData?
    }
    
}

public extension CoinGecko {
    struct MarketData: Codable {
        public let current_price: [String:Double]?
    }
}
