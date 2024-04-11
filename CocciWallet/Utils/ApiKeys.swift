//
//  ApiKeys.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/29/24.
//

import Foundation
import OffChainKit
import Web3Kit

fileprivate func valueForAPIKey(named keyName: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
        fatalError("Couldn't find file 'Secrets.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    
    let value = plist?.object(forKey: keyName) as? String
    
    return value!
}

extension CoinGecko {
    static var shared: CoinGecko {
        let api = valueForAPIKey(named: "coingecko_api_key")
        return .init(apiKey: api)
    }
}

extension Etherscan {
    static var shared: Etherscan {
        let api = valueForAPIKey(named: "etherscan_api_key")
        return .init(api_key: api, cache: UserDefaults.group)
    }
}

extension Infura {
    static var shared: Infura {
        let api = valueForAPIKey(named: "infura_api_key")
        return .init(api_key: api, session: .shared)
    }
}

extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.rifigy.CocciWallet")!
}
