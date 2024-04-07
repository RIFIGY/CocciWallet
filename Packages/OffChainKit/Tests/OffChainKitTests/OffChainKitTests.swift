import XCTest
@testable import OffChainKit

final class OffChainKitTests: XCTestCase {
    var client: CoinGecko!

    
    override func setUp() {
        super.setUp()
        self.client = CoinGecko()
    }
    func testIcons() {
        do {
            let icons = try JSON([Icon].self, resource: "icons", with: JSONDecoder())
            XCTAssert(icons.count > 200)
        } catch {
            XCTFail("Faiiled to fetch coingecko_currencies")
        }
    }
    
    func testLocalAssetPlatforms() {
        let ethereum = CoinGecko.AssetPlatform.NativeCoin(chainID: 1)
        let matic = CoinGecko.AssetPlatform.NativeCoin(chainID: 137)

        XCTAssertEqual(ethereum, "ethereum")
        XCTAssertEqual(matic, "matic-network")
    }
    
}
