import XCTest
import Foundation
@testable import Web3Kit
@testable import web3
@testable import BigInt

struct TestConfig {
    // This is the proxy URL for connecting to the Blockchain. For testing we usually use the Goerli network on Infura. Using free tier, so might hit rate limits
    static let clientUrl = "https://goerli.infura.io/v3/b2f4b3f635d8425c96854c3d28ba6bb0"
    static let mainnetUrl = "https://mainnet.infura.io/v3/b2f4b3f635d8425c96854c3d28ba6bb0"

    // This is the proxy wss URL for connecting to the Blockchain. For testing we usually use the Goerli network on Infura. Using free tier, so might hit rate limits
    static let wssUrl = "wss://goerli.infura.io/ws/v3/b2f4b3f635d8425c96854c3d28ba6bb0"
    static let wssMainnetUrl = "wss://mainnet.infura.io/ws/v3/b2f4b3f635d8425c96854c3d28ba6bb0"

    // An EOA with some Ether, so that we can test sending transactions (pay for gas). Set by CI
//    static let privateKey = "SET_YOUR_KEY_HERE"

    // This is the expected public key (address) from the above private key
//    static let publicKey = "SET_YOUR_PUBLIC_ADDRESS_HERE"

    // A test ERC20 token contract (UNI)
    static let erc20Contract = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"

    // A test ERC721 token contract (W3ST)
    static let erc721Contract = "0xb34354a70d2b985b031Ca443b87C92F7DaE5DA02"
    
    // MUNKO ERC721
    static let munkoContract = "0x885525B82e8ab86c5f463Cef0a4b19a43EF005c5"

    // ERC165 compliant contract
    static let erc165Contract = "0xA2618a1c426a1684E00cA85b5C736164AC391d35"

    static let webSocketConfig = WebSocketConfiguration(maxFrameSize: 1_000_000)

    static let network = EthereumNetwork.goerli

     enum ZKSync {
         static let chainId = 280
         static let network = EthereumNetwork.custom("\(280)")
         static let clientURL = URL(string: "https://zksync2-testnet.zksync.dev")!
    }
}

final class Web3KitTests: XCTestCase {
    var client: Web3Kit.EthereumClientProtocol!
    var coinGecko: CoinGecko!
//    var erc721: web3.ERC721!
//    var erc721Metadta: web3.ERC721Metadata!
    
    let address: EthereumAddress = .init("0x93d10aef2A21628C6ae5B5D91BF1312b522f626b")
    var addressString: String { address.asString() }

    override func setUp() {
        super.setUp()
        client = EthereumClient(rpc: URL(string: TestConfig.mainnetUrl)!, chain: 1) //EthereumHttpClient(url: URL(string: TestConfig.mainnetUrl)!, network: .mainnet)
        self.coinGecko = CoinGecko()
//        erc721 = .init(client: client)
//        erc721Metadta = web3.ERC721Metadata(client: client, metadataSession: .shared)
    }
    
    func testGetBalance() async {
        do {
            let balance = try await client.getBalance(address: addressString, block: nil)// eth_getBalance(address: address, block: .Latest)
            XCTAssertTrue(balance > 0)
        } catch {
            XCTFail("Expected balance but failed \(error).")

        }
    }
    
    func testERC721TokenGetURI() async {
        do {
            let uri = try await client.getERC721URI(contract: TestConfig.munkoContract, tokenId: 2309)// tokenURI(contract: .init(TestConfig.munkoContract), tokenID: 2309)
            XCTAssertEqual(uri.absoluteString.prefix(7), "ipfs://")
        } catch {
            XCTFail("Expected URI but failed \(error).")

        }
    }
    
    func testERC721Metadata() async {
        do {
            let uri = try await client.getERC721URI(contract: TestConfig.munkoContract, tokenId: 2309)
            let gateway = IPFS.gateway(uri: uri, .ipfs)
            let (data, _) = try await URLSession.shared.data(from: gateway)
            XCTAssertNotNil(data)
        } catch {
            XCTFail("Expected Metadata but failed \(error).")
        }
    }
    
    func testERC721Token() async {
        do {
            let token = try await client.getToken(erc721: .init(contract: TestConfig.munkoContract, name: "Munko", symbol: "MNKO"), tokenId: 2309)
            if let metadata = token.metadata {
                let metadata = try? JSONDecoder().decode(OpenSeaMetadata.self, from: metadata)
                let name = metadata?.name
                XCTAssertNotNil(metadata)
                XCTAssertNotNil(metadata?.image)
                if let name = metadata?.name {
                    XCTAssertEqual(name, "Munko #2309")
                }

            }
            XCTAssertNotNil(token)
        } catch {
            XCTFail("Expected Metadata but failed \(error).")
        }
    }
    
    func testERC721Tokens() async {
        let address = EthereumAddress(TestConfig.munkoContract)
        let tokenIds: [BigUInt] = [2309, 2310, 2311, 2312]
        let contract = Web3Kit.ERC721(contract: address.asString(), name: "Munko", symbol: "MNKO")
        
        do {
            let nfts = try await client.getERC721Tokens(contract: address.asString(), tokenIds: tokenIds)
            let nfts2 = try await client.getERC721Tokens(contract: address.asString(), tokenIds: tokenIds)
            XCTAssertEqual(nfts.count, tokenIds.count)
            XCTAssertEqual(nfts2.count, tokenIds.count)

        } catch {
            XCTFail("Expected NFT Array but failed \(error).")
        }
        
    }
}

extension Web3KitTests {

    func testCoinGeckoPrice() async {
        
        let ids = ["ethereum","bitcoin"]
        let currencies = ["usd"]
        
        do {
            let price = try await coinGecko.fetchPrices(platformIds: ids, currencies: currencies)
            let ethereum = price["ethereum"]?["usd"]
            let bitcoin = price["bitcoin"]?["usd"]
            
            XCTAssertNotNil(ethereum)
            XCTAssertNotNil(bitcoin)

        } catch {
            XCTFail("Expected Ethereum Price but failed \(error).")
        }
    }
    
    func testTokePrices() async {
        let platform = "ethereum"
        let tether = "0xdac17f958d2ee523a2206206994597c13d831ec7"
        let usdc = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
        let wbtc = "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
        
        let contracts = [tether, usdc, wbtc]
        let currencies = ["usd"]
        
        do {
            let price = try await coinGecko.fetchCryptoPrice(platform: platform, contract: contracts, currencies: currencies)
            XCTAssertEqual(price.keys.count, contracts.count)
        } catch {
            XCTFail("Expected Contract Prices but failed \(error).")
        }
        
    }
    
    func testLocalCoinGeckoId() {
        let coingecko = CoinGecko.PlatformID(.ETH)
        XCTAssertNotNil(coingecko)
        XCTAssertEqual(coingecko, "ethereum")

    }
}

extension Web3KitTests {
    
    func testEtherscanTransactions() async {
        let client = Etherscan(api_key: "")
        let address = "0x956d6A728483F2ecC1Ed3534B44902Ab17Ca81b0"
        do {
            let ethTXs = try await client.getTransactions(for: address, evm: .ETH)
            let maticTXs = try await client.getTransactions(for: address, evm: .MATIC)
            let avaxTXs = try await client.getTransactions(for: address, evm: .AVAX)

            XCTAssertGreaterThan(ethTXs.count, 2)
            XCTAssertGreaterThan(maticTXs.count, 2)
            XCTAssertGreaterThan(avaxTXs.count, 1)

        } catch {
            XCTFail("Expected Etherscan Transactions but failed \(error).")
        }
    }
}
