import XCTest
@testable import OffChainKit

final class EtherscanTests: XCTestCase {
    var client: Etherscan!
    
    override func setUp() {
        super.setUp()
        self.client = Etherscan(api_key: "")
    }
    
    func testEtherscanTransactions() async {
        do {
            let txs = try await client.getTransactions(for: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0")
            XCTAssertTrue(txs.count > 1, "Expected TXs to be more than 1, got \(txs.count)")
        } catch {
            XCTFail("Expected Etherscan Transactions \(error)")
        }
    }
    
    func testPolygonscanTransactions() async {
        let explorer = "polygonscan.com"
        do {
            let txs = try await client.getTransactions(for: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", explorer: explorer)
            XCTAssertTrue(txs.count > 1, "Expected TXs to be more than 1, got \(txs.count)")
        } catch {
            XCTFail("Expected Etherscan Transactions \(error)")
        }
    }
    
    func testAvalancheTransactions() async {
        let explorer = "snowtrace.io"
        do {
            let txs = try await client.getTransactions(for: "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0", explorer: explorer)
            XCTAssertTrue(txs.count > 1, "Expected TXs to be more than 1, got \(txs.count)")
        } catch {
            XCTFail("Expected Etherscan Transactions \(error)")
        }
    }
    
}
