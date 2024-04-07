//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/25/24.
//

import Foundation

public extension CoinGecko {
    
    struct AssetPlatform: Identifiable, Codable {
        public let id: String
        public let chainIdentifier: Int?
        public let name: String
        public let shortname: String
        public let nativeCoinId: String
        
        public struct Asset: Hashable {
            public let platformId, contract: String
            
            public init(platformId: String, contract: String) {
                self.platformId = platformId
                self.contract = contract
            }
        }
    }
}



extension CoinGecko.AssetPlatform {
    
    static var ETH: CoinGecko.AssetPlatform {.init(
        id: "ethereum", chainIdentifier: 1, name: "Ethereum", shortname: "Ethereum", nativeCoinId: "ethereum")
        
    }
    
    private static func getPlatform(for chain: Int) -> CoinGecko.AssetPlatform? {
        guard chain != 1 else {return .ETH}
        let blockchains = try? JSON([CoinGecko.AssetPlatform].self,
                                    resource: "coingecko_asset_platforms",
                                    with: CoinGecko.Decoder )
        
        return blockchains?.first{$0.chainIdentifier == chain }
    }
    
    public static func NativeCoin(chainID: Int) -> String? {
        getPlatform(for: chainID)?.nativeCoinId
    }
    
    public static func PlatformID(chainID: Int) -> String? {
        getPlatform(for: chainID)?.id
    }


}



