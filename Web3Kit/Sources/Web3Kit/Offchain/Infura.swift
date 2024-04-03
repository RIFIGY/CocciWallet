//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/7/24.
//

import Foundation

public struct Infura {
    fileprivate let API_KEY: String
    fileprivate let base = ".infura.io/"
    
    private let session: URLSession
    
    public init(
        api_key: String,
        session: URLSession
    ){
        self.API_KEY = api_key
        self.session = session
    }
    
    public func URL(evm: EVM, websocket: Bool = false) -> Foundation.URL? {
        guard let chain = evm.infuraChain else {return nil}
        return URL(chain: chain, websocket: websocket)
    }

        
    public func URL(chain: Chain = .mainnet, websocket: Bool = false) -> Foundation.URL {
        let version = websocket ? "ws/v3/" : "v3/"
        let chain = chain.name
        let clientUrl = Foundation.URL(string:
            "https://" + chain + base + version + API_KEY
        )
        return clientUrl!
    }
    
    public func ping() async throws -> Bool {
        return true
    }
    
    
}

extension Infura {
    public enum Chain: String, Identifiable, CaseIterable {
        public var id: String { rawValue }
        case mainnet, sepolia, goerli
        case polygon
        case arbitrum
        case avalanche

        public init?(chainId: Int) {
            switch chainId {
            case 1:
                self = .mainnet
            case 11155111:
                self = .sepolia
            case 5:
                self = .goerli
            case 137:
                self = .polygon
            case 42161:
                self = .arbitrum
            case 43114:
                self = .avalanche
            default:
                return nil
            }
        }
        
        public var name: String {
            switch self {
            case .polygon:
                "\(rawValue)-mainnet"
            case .arbitrum:
                "\(rawValue)-mainnet"
            case .avalanche:
                "\(rawValue)-mainnet"
            default: rawValue
            }
        }
        
        public var symbol: String {
            switch self {
            case .sepolia:
                return "sepoliaETH"
            case .goerli:
                return "goerliETH"
            case .polygon:
                return "MATIC"
            case .avalanche:
                return "AVAX"
            default:
                return "ETH"
            }
        }
    }

}

extension EVM {
    public var infuraChain: Infura.Chain? {
        .init(chainId: self.chain)
    }
}
