//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/7/24.
//

import Foundation

public class CoinGecko {
    private let baseURL = "https://api.coingecko.com/api/v3"
    private let API_KEY: String?
    private let session: URLSession
    private let cache: (any Cache)?
    
    
    public init(
        session: URLSession = URLSession.shared,
        cache: (any Cache)? = nil,
        apiKey: String?
    ) {
        self.session = session
        self.cache = cache
        self.API_KEY = apiKey
    }
    
    private func fetch(_ urlString: String) async throws -> Data {
        var urlString = urlString
        if let API_KEY {
            urlString = urlString + "&x_cg_demo_api_key=\(API_KEY)"
        }
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "CoinGeckoAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            if (400...599).contains(httpResponse.statusCode) {
                try parse(data: data, url: url)
            }
        }
        return data
    }
    
    fileprivate func parse(data: Data, url: URL) throws {
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]

        if let dictionary {
            // Check for specific CoinGecko API error regarding contract address limit
            if let error_code = dictionary["error_code"] as? Int,
               let errorMessage = dictionary["status"] as? [String: Any],
               let message = errorMessage["error_message"] as? String {
                throw NSError(domain: "CoinGeckoAPI", code: error_code, userInfo: [NSLocalizedDescriptionKey: message])
            } else if let errorMessage = dictionary["error"] as? String {
                throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            } else {
                throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "An error occurred with the request \(url)"])
            }
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "An error occurred with the request \(url)"])
        }
    }

    
    public func fetchCoin(coinId: String) async throws -> CoinGecko.Coin {
        let urlString = "\(baseURL)/coins/\(coinId)"
        let data = try await fetch(urlString)
        return try JSONDecoder().decode(CoinGecko.Coin.self, from: data)
    }
    
    public func fetchPlatformAsset(platform: String, contract: String) async throws -> CoinGecko.Coin {
        let urlString = "\(baseURL)/coins/\(platform)/contract/\(contract)"
        let data = try await fetch(urlString)
        return try JSONDecoder().decode(CoinGecko.Coin.self, from: data)

    }
    
    public func fetchPrice(coin: String, currency: String) async throws -> Double {
        let urlString = "\(baseURL)/simple/price?ids=\(coin)&vs_currencies=\(currency)"
        let data = try await fetch(urlString)
        let prices = try JSONSerialization.jsonObject(with: data, options: []) as? CoinPrices
        if let price = prices?[coin]?[currency] {
            return price
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON CoinPrices"])
        }

    }
    
    public func fetchPrice(platform: String, contract: String, currency: String) async throws -> Double {
        let urlString = "\(baseURL)/simple/token_price/\(platform)?contract_addresses=\(contract)&vs_currencies=\(currency)"
        let data = try await fetch(urlString)
        
        let prices = try JSONSerialization.jsonObject(with: data, options: []) as? ContractPrices
        
        if let price = prices?[contract]?[currency] {
            return price
        } else if let price = prices?[contract.lowercased()]?[currency] {
            return price
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Error parsing price from contract"])
        }
    }
    
    
    public func fetchPrices(coins ids: [String], currency: String) async throws -> [String:Double] {
        let ids = ids.joined(separator: ",")

        let urlString = "\(baseURL)/simple/price?ids=\(ids)&vs_currencies=\(currency)"
        let data = try await fetch(urlString)
            
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? CoinPrices
        
        if let priceSheet = json  {
            return priceSheet.reduce(into: [String:Double]()) { partialResult, result in
                partialResult[result.key] = result.value[currency]
            }
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"])
        }
    }
    
    
    public func fetchAssetPrices(platform: String, contracts addresses: [String], currency: String) async throws -> [String:Double] {
        let addresses = addresses.joined(separator: ",")

        let urlString = "\(baseURL)/simple/token_price/\(platform)?contract_addresses=\(addresses)&vs_currencies=\(currency)"

        let data = try await fetch(urlString)
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : PriceSheet]
            
        if let priceSheet = json  {
            return priceSheet.reduce(into: [String:Double]()) { partialResult, result in
                partialResult[result.key] = result.value[currency]
            }
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"])
        }
    }

    
}


// MARK: Price History
extension CoinGecko {
    
    
    public func fetchPriceHistory(platform id: String, contract: String? = nil, currency: String, timespan: Calendar.Component, amount: Int) async throws -> [PriceHistory.Price] {
        
        guard let apiFrequency = timespan.frequency, let apiSpan = timespan.span else {
            throw NSError(domain: "CoinGecko Price History", code: 2)
        }
                
        var urlString = "\(baseURL)/coins/\(id)"
        let marketEndUrl = "/market_chart?vs_currency=\(currency)&\(apiSpan)=\(amount)&interval=\(apiFrequency)"
        
        if let contract {
            urlString = urlString + "/contract/\(contract)" + marketEndUrl
        } else {
            urlString = urlString + marketEndUrl
        }
        
        let data = try await fetch(urlString)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        guard let json, let array = json["prices"] as? [[Double]] else {
            throw NSError(domain: "CoinGecko Price History", code: 2)
        }
        
        return array.map { PriceHistory.Price(array: $0) }
    }
    
    public func fetchPriceHistory(coin id: String, currency: String, timespan: Calendar.Component, amount: Int) async throws -> [PriceHistory.Price] {
        
        guard let apiFrequency = timespan.frequency, let apiSpan = timespan.span else {
            throw NSError(domain: "CoinGecko Price History", code: 2)
        }
                
        let urlString = "\(baseURL)/coins/\(id)/market_chart?vs_currency=\(currency)&\(apiSpan)=\(amount)&interval=\(apiFrequency)"
        
        let data = try await fetch(urlString)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        guard let json, let array = json["prices"] as? [[Double]] else {
            throw NSError(domain: "CoinGecko Price History", code: 2)
        }
        
        return array.map { PriceHistory.Price(array: $0) }
    }
}




//extension CoinGecko {
//    
//    public func fetchPrice(coin id: String, currency: String) async throws -> Double {
//        let platformPrices = try await fetchPrices(coins: id, currencies: currency)
//        if let price = platformPrices[id]?[currency] {
//            return price
//        } else {
//            throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"])
//        }
//    }
//    
//    public func fetchPrices(coins ids: [String], currencies: [String]) async throws -> CoinPrices {
//        let ids = ids.joined(separator: ",")
//        let currencies = currencies.joined(separator: ",")
//        
//        return try await fetchPrices(coins: ids, currencies: currencies)
//    }
//
//    
//    public func fetchAssetPrices(platform: String, contracts addresses: [String], currencies: [String]) async throws -> PlatformAssetPrices {
//        let contracts = addresses.joined(separator: ",")
//        let currencies = currencies.joined(separator: ",")
//        
//        return try await fetchAssetPrices(platform: platform, contracts: contracts, currencies: currencies)
//    }
//    
//    public func fetchAssetPrices(platforms: [ ( String, [String] ) ], currencies: [String]) async throws -> PlatformAssetPrices {
//        await withTaskGroup(of: PlatformAssetPrices?.self) { group in
//            platforms.forEach { platform, contracts in
//                group.addTask {
//                    try? await self.fetchAssetPrices(platform: platform, contracts: contracts, currencies: currencies)
//                }
//            }
//            return await group.reduce(into: PlatformAssetPrices()) { partialResult, assetPrices in
//                if let assetPrices, let platform = assetPrices.keys.first, let prices = assetPrices[platform] {
//                    partialResult[platform] = prices
//                }
//            }
//        }
//    }
//    
//    public func fetchPriceHistory(coin id: String, contract: String? = nil, currency: String, timespan: Calendar.Component, amount: Int) async throws -> PriceHistory {
//        
//        let priceArray: [PriceHistory.Price] = try await fetchPriceHistory(coin: id, contract: contract, currency: currency, timespan: timespan, amount: amount)
//
//        return PriceHistory(currency: currency, timespan: timespan, frequency: amount, prices: priceArray)
//
//    }
//    
//
//    
//    public func fetchPriceHistories(coins: [String], currency: String, timespan: Calendar.Component, amount: Int) async -> [PriceHistory] {
//        return await withTaskGroup(of: PriceHistory?.self) { group in
//            coins.forEach { coin in
//                group.addTask {
//                    try? await self.fetchPriceHistory(coin: coin, currency: currency, timespan: timespan, amount: amount)
//                }
//            }
//            
//            return await group.reduce(into: [PriceHistory]()) { partialResult, history in
//                if let history {
//                    partialResult.append(history)
//                }
//            }
//        }
//    }
//    
//    public func fetchPriceHistories(contracts: [ String : [String] ], currency: String, timespan: Calendar.Component, amount: Int) async -> [String : PriceHistory] {
//        return await withTaskGroup(of: (String, PriceHistory?).self) { group in
//            contracts.forEach { coin, contracts in
//                contracts.forEach { contract in
//                    group.addTask {
//                        let history: PriceHistory? = try? await self.fetchPriceHistory(coin: coin, contract: contract, currency: currency, timespan: timespan, amount: amount)
//                        return (contract, history)
//                    }
//                }
//            }
//            
//            return await group.reduce(into: [String: PriceHistory]()) { partialResult, result in
//                if let history = result.1 {
//                    partialResult[result.0] = history
//                }
//            }
//        }
//
//    }
//
//    
//    public func fetchPriceHistories(coins: String, currency: String, timespan: Calendar.Component, amount: Int) async -> [PriceHistory] {
//        let coins = coins.components(separatedBy: ",")
//        return await fetchPriceHistories(coins: coins, currency: currency, timespan: timespan, amount: amount)
//    }
//}
