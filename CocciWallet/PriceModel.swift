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

typealias PriceModel = Prices

@Observable
class Prices {
    
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

extension Prices {
    
    func fetch(coin id: String, currency: String) {
        Task {
            do {
                let price = try await api.fetchPrice(coin: id, currency: currency)
                withAnimation {
                    self.prices[id] = [currency:price]
                }
            } catch {
                print("Price Error: \(error)")
            }
        }
    }
    
    func fetch(coinIDs ids: String, currency: String) {
        let ids = ids.components(separatedBy: ",")

        Task {
            do {
                let prices = try await api.fetchPrices(coins: ids, currency: currency)
                
                let sheet = prices.reduce(into: [String : Price]()) { partialResult, result in
                    let (id, price) = result
                    partialResult[id] = [currency:price]
                }
                withAnimation {
                    self.prices = sheet
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
    
    func fetchPrices(chain: Int, contracts: [String], currency: String) async {
        guard let platform = CoinGecko.AssetPlatform.PlatformID(chainID: chain) else {return}
        await fetchPrices(contracts: contracts, platform: platform, currency: currency)
    }
    
    
}
