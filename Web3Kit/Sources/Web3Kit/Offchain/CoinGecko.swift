//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/7/24.
//

import Foundation

public class CoinGecko {
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    private let session: URLSession
    private let cache: (any Cache)?
    
    static let shared = CoinGecko()
    
    public init(
        session: URLSession = URLSession.shared,
        cache: (any Cache)? = nil
    ) {
        self.session = session
        self.cache = cache
    }
    
    private func fetch(_ urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "CoinGeckoAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let (data, _) = try await session.data(from: url)
        
        return data
    }
    
    
    public func fetchPriceHistory(for id: String, currency: String, timespan: Calendar.Component, amount: Int) async throws -> Prices {
        
        
        guard let frequency = timespan.frequency, let span = timespan.span else {
            throw NSError(domain: "CoinGecko Price History", code: 2)
        }
        
        let key = "history_\(id)_\(currency)_\(span)_\(amount)"
        
        if let prices = cache?.fetch(Prices.self, for: key) {
            return prices
        }

        
        let urlString = "\(baseURL)/coins/\(id)/market_chart?vs_currency=\(currency)&\(span)=\(amount)&interval=\(frequency)"
        
        let data = try await fetch(urlString)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        if let json, let array = json["prices"] as? [[Double]] {
            
            let priceArray = array.map { (element: [Double]) -> Price in
                let date = Date(timeIntervalSince1970: element[0] / 1000) // Convert milliseconds to seconds
                let value = element[1]
                return Price(date: date, value: value)
            }
            let prices = Prices(currency: currency, component: .init(component: timespan, value: amount), prices: priceArray)
            cache?.store(prices, forKey: key)
            return prices
        } else {
            throw NSError(domain: "CoinGecko Price History", code: 2)
        }

    }
    
    
    public func fetchPrices(platformIds ids: String, currencies: String = "usd") async throws -> [String:[String:Double]] {
        
        let urlString = "\(baseURL)/simple/price?ids=\(ids)&vs_currencies=\(currencies)"
        
        print(urlString)
        let data = try await fetch(urlString)
            
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        if let priceSheet = json as? [String : [String:Double]] {
        
//        if let priceSheet = json?[id] as? [String:Double] {
            return priceSheet
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"])
        }
    }
    
    public func fetchPrices(platformIds ids: [String], currencies: [String] = ["usd"]) async throws -> [String:[String:Double]] {
        let ids = ids.joined(separator: ",")
        let currencies = currencies.joined(separator: ",")
        
        return try await fetchPrices(platformIds: ids, currencies: currencies)
    }
    
    public func fetchCryptoPrice(coingeckId id: String, currency: String = "usd") async throws -> [String:Double] {
        let urlString = "\(baseURL)/simple/price?ids=\(id)&vs_currencies=\(currency)"
        let key = "coingecko_price_\(id)_\(currency)"
        
        print(urlString)
        let data = try await fetch(urlString)
            
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let priceSheet = json?[id] as? [String:Double]
        
        if let priceSheet {
            return priceSheet
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"])
        }
    }
    
    public func fetchCryptoPrice(platform:String, contract addresses: [String], currencies: [String] = ["usd"]) async throws -> [String:[String:Double]] {
        let ids = addresses.joined(separator: ",")
        let currencies = currencies.joined(separator: ",")

        let urlString = "\(baseURL)/simple/token_price/\(platform)?contract_addresses=\(ids)&vs_currencies=\(currencies)"
        let key = "coingecko_price_\(platform)_\(ids)_\(currencies)"
        let data = try await fetch(urlString)
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let priceSheet = json as? [String: [ String : Double ]]
            
        if let priceSheet {
            return priceSheet
        } else {
            throw NSError(domain: "CoinGeckoAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"])
        }
//        var prices: [String : [String:Double] ] = [:]
//        json?.keys.forEach {
//            prices[$0] = json?[$0] as? [String:Double] ?? [:]
//        }
//        
//        return prices

    }
    
    public static func PlatformID(_ evm: EVM) -> String? {
        guard evm.chain != 1 else {return "ethereum"}
        guard let bundlePath = Bundle.module.url(forResource: "coingeck_asset_platforms", withExtension: "json") else {
            return nil
        }
        if let data = try? Data(contentsOf: bundlePath),
           let keys = try? JSONDecoder().decode([CoinGecko.Blockchain].self, from: data) {
            return keys.first{$0.chain_identifier == evm.chain }?.native_coin_id
        } else {
            return nil
        }
    }
    
}

extension Calendar.Component {
    var span: String? {
        switch self {
        case .day:
            return "days"
        case .year:
            return "years"
        case .month:
            return "months"
        case .minute:
            return "minutes"
        case .weekOfYear, .weekOfMonth:
            return "weeks"
        default:
            return nil
        }
    }

    var frequency: String? {
        switch self {
        case .day:
            return "daily"
        case .year:
            return "yearly"
        case .month:
            return "monthly"
        case .minute:
            return "minutely"
        case .weekOfYear, .weekOfMonth:
            return "weekly"
        default:
            return nil
        }
    }
}



extension CoinGecko {
    public struct Blockchain: Codable {
        public let id: String
        public let chain_identifier: Int?
        public let name: String?
        public let shortname: String?
        public let native_coin_id: String?
        
    }
    
    public struct PlatformContract: Hashable {
        public let platform, contract: String
        public init(platform: String, contract: String) {
            self.platform = platform
            self.contract = contract
        }
    }
    
    public struct Price: Codable {
        public let date: Date
        public let value: Double
    }
    
    public struct Prices: Codable {
        public let currency: String
        public let component: TimeComponent?
        
        public let prices: [Price]
    }
}

extension CoinGecko {

    public enum TimeComponentOptions: String, Codable {
        case day
        case year
        case month
        case minute
        case week

        public init?(component: Calendar.Component) {
            switch component {
            case .day:
                self = .day
            case .year:
                self = .year
            case .month:
                self = .month
            case .minute:
                self = .minute
            case .weekOfYear, .weekOfMonth:
                self = .week
            default:
                return nil
            }
        }

        public var calendarComponent: Calendar.Component {
            switch self {
            case .day:
                return .day
            case .year:
                return .year
            case .month:
                return .month
            case .minute:
                return .minute
            case .week:
                return .weekOfYear
            }
        }
        
        public var span: String {
            switch self {
            case .day:
                return "days"
            case .year:
                return "years"
            case .month:
                return "months"
            case .minute:
                return "minutes"
            case .week:
                return "weeks"
            }
        }

        public var frequency: String {
            switch self {
            case .day:
                return "daily"
            case .year:
                return "yearly"
            case .month:
                return "monthly"
            case .minute:
                return "minutely"
            case .week:
                return "weekly"
            }
        }
    }

    public struct TimeComponent: Codable {
        private let codableComponent: TimeComponentOptions
        public var component: Calendar.Component {
            codableComponent.calendarComponent
        }
        public var span: String {
            codableComponent.span
        }
        public var frequency: String {
            codableComponent.frequency
        }
        public let value: Int

        public init?(component: Calendar.Component, value: Int) {
            guard let codableComponent = TimeComponentOptions(component: component) else {
                return nil
            }
            self.codableComponent = codableComponent
            self.value = value
        }
    }

}
public extension CoinGecko {
    static let Currencies: [String] = [
        "btc",
        "eth",
        "ltc",
        "bch",
        "bnb",
        "eos",
        "xrp",
        "xlm",
        "link",
        "dot",
        "yfi",
        "usd",
        "aed",
        "ars",
        "aud",
        "bdt",
        "bhd",
        "bmd",
        "brl",
        "cad",
        "chf",
        "clp",
        "cny",
        "czk",
        "dkk",
        "eur",
        "gbp",
        "gel",
        "hkd",
        "huf",
        "idr",
        "ils",
        "inr",
        "jpy",
        "krw",
        "kwd",
        "lkr",
        "mmk",
        "mxn",
        "myr",
        "ngn",
        "nok",
        "nzd",
        "php",
        "pkr",
        "pln",
        "rub",
        "sar",
        "sek",
        "sgd",
        "thb",
        "try",
        "twd",
        "uah",
        "vef",
        "vnd",
        "zar",
        "xdr",
        "xag",
        "xau",
        "bits",
        "sats"
      ]
}
