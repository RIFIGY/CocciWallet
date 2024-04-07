import XCTest
import Foundation
@testable import OffChainKit

final class IPFSTests: XCTestCase {
    let ipfsString = "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/d9c8d4b7886844779f25fb44fc721117eb0d290415c54a03926e3f0d0f3e1590.jpg"
    var url: URL { URL(string: ipfsString)! }
    
    func testIpfsGateway()  {
        let gateway = IPFS.Gateway(url)
        XCTAssertEqual("https", gateway.absoluteString.prefix(5))
    }
    
    func testIpfsGatewayData() async {
        do {
            let gateway = IPFS.Gateway(url)
            let data = try await URLSession.shared.data(from: gateway)
            XCTAssertNotNil(data)
        } catch {
            XCTFail("Expected Image Data from gateway url \(error)")
        }
    }
}
