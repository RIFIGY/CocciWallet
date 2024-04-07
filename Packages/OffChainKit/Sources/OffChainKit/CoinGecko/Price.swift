//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/25/24.
//

import Foundation



extension CoinGecko {
    
    public typealias PriceSheet = [ String : Double ] // currency : value
    
    public typealias CoinPrices = [ String : PriceSheet ] // coinId : priceSheet
    
    public typealias ContractPrices = [ String : PriceSheet ] // contract : priceSheet
    
    public typealias PlatformAssetPrices = [ String : ContractPrices ] // platformId : conractprices

    
    public struct PriceHistory: Codable {
        public let currency: String
        public let component: TimeComponent?
        
        public let prices: [Price]
        
        init(currency: String, timespan: Calendar.Component, frequency: Int, prices: [Price]) {
            self.currency = currency
            self.component = .init(component: timespan, value: frequency)
            self.prices = prices
        }
        
        public struct Price: Codable {
            public let date: Date
            public let value: Double
            
            init(array: [Double]) {
                self.date = Date(timeIntervalSince1970: array[0] / 1000) // Convert milliseconds to seconds
                self.value = array[1]
            }
        }
    }
    
}


