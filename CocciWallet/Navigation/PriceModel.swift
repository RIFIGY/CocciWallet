//
//  PriceModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import Foundation
import OffChainKit
import SwiftUI
//typealias PlatformID = CoinGecko.PlatformContract

@Observable
class PriceModel {
    
    private let api = CoinGecko.shared
        
    typealias Price = [String:Double]
    
    var prices: [String:Price] = [:] // coinId : priceSheet
    
    var platformPrices: [String: [String : Price] ] = [:] // platformId : [contract : priceSheet]

    var priceHistory: [String : [CoinGecko.PriceHistory.Price] ] = [:] // coinId : pricedata

    var contractPrices: [String: Price] = [:] // contract : priceSheet

    func price(coin id: String, currency: String) -> Double? {
        let id = id.lowercased()
        let currency = currency.lowercased()
        return prices[id]?[currency]
    }
    
    func price(platform: String, contract: String? = nil, currency: String) -> Double? {
        let platform = platform.lowercased()
        let contract = contract?.lowercased()
        let currency = currency.lowercased()
        
        var price: Double? = self.prices[platform]?[currency]
        
        if let contract {
            price = self.platformPrices[platform]?[contract]?[currency]
        }
        return price
    }
    
    func price(contract: String, currency: String) -> Double? {
        let contract = contract.lowercased()
        let currency = currency.lowercased()
        
        return self.contractPrices[contract]?[currency]

    }
    
    func price(chain: Int, contract: String? = nil, currency: String) -> Double? {
        if let contract, let platform = CoinGecko.AssetPlatform.PlatformID(chainID: chain) {
            return price(platform: platform, contract: contract, currency: currency)
            
        } else if let coin = CoinGecko.AssetPlatform.NativeCoin(chainID: chain) {
            
            return price(coin: coin, currency: currency)
        } else {
            return nil
        }
    }
    
}

extension PriceModel {
    
    func fetchPrices(coinIDs ids: String, currency: String) {
        let ids = ids.components(separatedBy: ",")

        Task {
            do {
                let prices = try await api.fetchPrices(coins: ids, currency: currency)
                prices.forEach { key, value in
                    let coin = key.lowercased()
                    let currency = currency.lowercased()
                    
                    withAnimation {
                        self.prices[coin] = [currency:value]
                    }
                }
            } catch {
                print("Price Error: \(error)")
            }
        }
    }

    
    func fetchPrices(contracts: [String], platform: String, currency: String) async {
        do {
            let prices = try await api.fetchAssetPrices(platform: platform, contracts: contracts, currency: currency)
            prices.forEach { key, value in
                let platform = platform.lowercased()
                let contract = key.lowercased()
                let currency = currency.lowercased()
                withAnimation {
                    platformPrices[platform, default: [:]][contract] = [currency: value]
                    contractPrices[contract] = [currency:value]
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
