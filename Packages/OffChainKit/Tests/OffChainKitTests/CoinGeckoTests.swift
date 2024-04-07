import XCTest
@testable import OffChainKit

final class CoinGeckoTests: XCTestCase {
    var client: CoinGecko!
    
    override func setUp() {
        super.setUp()
        self.client = CoinGecko(apiKey: nil)
    }
    
    func testCoin() async {
        let id = "bitcoin"
        let currency = "usd"
        do {
            let coin = try await client.fetchCoin(coinId: id)
            XCTAssert(coin.name == "Bitcoin")
            XCTAssertNotNil(coin.market_data?.current_price?[currency])
        } catch {
            XCTFail("Expected to fetch CoinGecko.Coin struct")
        }
    }
    
    func testPlatformAssetCoin() async {
        let platform = "ethereum"
        let contract = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
        let currency = "usd"
        do {
            let coin = try await client.fetchPlatformAsset(platform: platform, contract: contract)
            XCTAssert(coin.name == "USDC", "Expected USD Coin but returned \(coin.name)")
            XCTAssertNotNil(coin.market_data?.current_price?[currency])
        } catch {
            XCTFail("Expected to fetch CoinGecko.Coin struct \(error)")
        }
    }
    
    func testPrice() async {
        let coin = "ethereum"
        let currency = "usd"
        
        do {
            let price = try await client.fetchPrice(coin: coin, currency: currency)
            XCTAssert(price > 100)
        } catch {
            XCTFail("Coigecko Price fail \(error)")
        }
    }
    
    func testPrices() async {
        let coins = ["ethereum", "bitcoin"]
        let currency = "usd"

        do {
            let prices = try await client.fetchPrices(coins: coins, currency: currency)
            for coin in coins {
                if prices[coin] == nil {
                    XCTFail("Expected \(coin) Price for \(currency)")

                }
            }
            XCTAssert(true)
        } catch {
            XCTFail("Coigecko Price fail \(error)")
        }
    }
    
    func testAssetPrice() async {
        let platform = "ethereum"
        let currency = "usd"
        let contract = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
        do {
            let price = try await client.fetchPrice(platform: platform, contract: contract, currency: currency)
            XCTAssertEqual(Int(price), 1, "Expected USDC price to be 1.00 got \(price)")
        } catch {
            let url = "https://api.coingecko.com/api/v3/simple/token_price/\(platform)?contract_addresses=\(contract)&vs_currencies=\(currency)"
            XCTFail(url)
        }
    }
    
    func testAssetPrices() async {
        let platform = "ethereum"
        let currency = "usd"
        let contracts = [
            "0xdAC17F958D2ee523a2206206994597C13D831ec7", // USDT (Tether)
            "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC (USD Coin)
            "0x514910771AF9Ca656af840dff83E8264EcF986CA", // LINK (Chainlink)
            "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI (Uniswap)
            "0x6B175474E89094C44Da98b954EedeAC495271d0F"  // DAI (Dai)
        ]
        do {
            let prices = try await client.fetchAssetPrices(platform: platform, contracts: contracts, currency: currency)
            for contract in contracts {
                if prices[contract] == nil {
                    XCTFail("Expected \(contract) Price for \(currency)")
                }
            }
            XCTAssert(true)
        } catch {
            
        }
    }
    
    func testPriceHistory() async {
        let coin = "ethereum"
        let currency = "usd"
        do {
            let priceHistory = try await client.fetchPriceHistory(coin: coin, currency: currency, timespan: .day, amount: 30)
            XCTAssertTrue(priceHistory.count == 31, "Expected 30 Prices got \(priceHistory.count)")
        } catch {
            XCTFail("Expected 30 Day Price History \(error)")
        }
    }
    
    func testPriceHistoryContract() async {
        let platform = "ethereum"
        let currency = "usd"
        let contract = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
        do {
            let priceHistory = try await client.fetchPriceHistory(platform: platform, contract: contract, currency: currency, timespan: .day, amount: 30)
            XCTAssertTrue(priceHistory.count == 31, "Expected 30 Prices got \(priceHistory.count)")
        } catch {
            XCTFail("Expected 30 Day Price History \(error)")
        }
    }
    
//    func testPriceHistoryCoins() async {
//        let coins = ["bitcoin", "ethereum"]
//        let currency = "usd"
//        let frequency = 30
//        
//        let prices = await client.fetchPriceHistories(coins: coins, currency: currency, timespan: .day, amount: frequency)
//        XCTAssert(prices.count == coins.count)
//        
//        for price in prices {
//            XCTAssert(price.prices.count == frequency + 1)
//        }
//    }
    
//    func testPriceHistoryContracts() async {
//        let coins = ["ethereum"]
//        let contracts = [
//            "0xdAC17F958D2ee523a2206206994597C13D831ec7", // USDT (Tether)
//            "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC (USD Coin)
//            "0x514910771AF9Ca656af840dff83E8264EcF986CA", // LINK (Chainlink)
//            "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI (Uniswap)
//            "0x6B175474E89094C44Da98b954EedeAC495271d0F"  // DAI (Dai)
//        ]
//        let currency = "usd"
//        let frequency = 30
//        
//        let dict = ["ethereum" : contracts]
//        
//        let prices = await client.fetchPriceHistories(contracts: dict, currency: currency, timespan: .day, amount: frequency)
//        XCTAssertTrue(prices.keys.count == contracts.count, "Expected \(contracts.count) Histories but got \(prices.keys.count)")
//        
//        for contract in prices.keys {
//            if let history = prices[contract] {
//                XCTAssert(history.prices.count == frequency + 1)
//            } else {
//                XCTAssertNotNil(prices[contract])
//            }
//        }
//    }
}
