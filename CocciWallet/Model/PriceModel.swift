//
//  PriceModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/21/24.
//

import Foundation
import Web3Kit

typealias PlatformID = CoinGecko.PlatformContract

@Observable
class PriceModel {
    
    private let api = CoinGecko(cache: UserDefaults.standard)
    
    typealias ContractSheet = [ String : [ String : Double ] ]
    typealias PlatformSheet = [ String : ContractSheet ]
    
    var prices: [ String : [String : Double] ] = [:] // coingecko id : currency : price
    var priceHistory: [String : CoinGecko.Prices ] = [:] // coingecko id : pricedata

    var platformPrices: PlatformSheet = [:] // (coingeckoId, contract) : price

    
//    func value(balances: [(EVM, Double?)], currency: String = "usd") -> Double {
//        
//        var total: Double = 0
//        for (evm, balance) in balances {
//            if let id = evm.coingecko {
//                if let price = prices[id]?[currency], let balance {
//                    total += (balance * price)
//                }
//            }
//        }
//        return total
//    }
    
    func price(id: String?, contract: String? = nil, currency: String = "usd") -> (Double, String)? {
        guard let platform = id else {return nil}
                
        var price: Double? = self.prices[platform]?[currency]
        
        if let contract {
            price = self.platformPrices[platform]?[contract]?[currency]
        }
        
        if let price {
            return (price, currency)
        } else {
            return nil
        }
    }
    
    func price(evm: EVM, contract: String? = nil, currency: String = "usd") -> (Double, String)? {
        guard let platform = evm.coingecko else {return nil}
                
        var price: Double? = self.prices[platform]?[currency]
        
        if let contract {
            price = self.platformPrices[platform]?[contract]?[currency]
        }
        
        if let price {
            return (price, currency)
        } else {
            return nil
        }
    }
    
}

extension PriceModel {
    
    func fetchPrice(for evm: EVM, currency: String = "usd") async {
        guard let coingecko = evm.coingecko else {return}
        do {
            let price = try await api.fetchCryptoPrice(coingeckId: coingecko, currency: currency)
            self.prices[coingecko] = price
            let priceHistory = try await api.fetchPriceHistory(for: coingecko, currency: currency, timespan: .day, amount: 30)
            self.priceHistory[coingecko] = priceHistory
        } catch {
            print(error)
        }
    }
    
    func fetchPrice(for token: ERC20, in evm: EVM, currency: String = "usd") async {
        guard let platform = evm.coingecko else {return}
        do {
            let priceSheet = try await api.fetchCryptoPrice(platform: platform, contract: [token.contract], currencies: [currency])
            guard let price = priceSheet[token.contract] else {return}
            self.platformPrices[platform]?[token.contract] = price
            
        } catch {
            print("Price Error \(token.name ?? token.contract.shortened()): \(error)")
        }
    }
    
    func fetchPrices(platformIds ids: String, currencies: String = "usd") async {
        
        do {
            let prices = try await api.fetchPrices(platformIds: ids, currencies: currencies)
            self.prices = prices
        } catch {
            print("Price Error: \(error)")
        }
        
//        await withTaskGroup(of: (String, CoinGecko.Prices?).self) { group in
//            ids.forEach{ id in
//                group.addTask {
//                    let prices = try? await self.api.fetchPriceHistory(
//                            for: id,
//                            currency: currency,
//                            timespan: .day,
//                            amount: 30
//                        )
//                    return (id, prices)
//                }
//
//            }
//            
//            for await result in group {
//                if let price = result.1 {
//                    self.priceHistory[result.0] = price
//                }
//            }
//        }
    }
    
    func fetchPrices(platformIds ids: [String], currency: String = "usd") async {
        do {
            let prices = try await api.fetchPrices(platformIds: ids, currencies: [currency])
            self.prices = prices
        } catch {
            print("Price Error: \(error)")
        }
    }
    
    func fetchPrices(platformContracts ids: [ ( String, [String] ) ], currency: String = "usd") async {

        
        await withTaskGroup(of: (String, ContractSheet)?.self) { group in
            ids.forEach { (platform, contracts) in
                group.addTask {
                    if let sheet = try? await self.api.fetchCryptoPrice(platform: platform, contract: contracts, currencies: [currency]) {
                        return (platform, sheet)
                    } else {
                        return nil
                    }
                }
            }
            
            for await platformSheet in group {
                if let platformSheet {
                    self.platformPrices[platformSheet.0] = platformSheet.1
                }
            }
        }
        print("Platform Prices")
        print(platformPrices)
        
//        let platform = ""
//        let contracts = [""]
//        do {
//            let priceSheet =
//        } catch {
//            print("Price Error: \(error)")
//        }
        
    }
}
