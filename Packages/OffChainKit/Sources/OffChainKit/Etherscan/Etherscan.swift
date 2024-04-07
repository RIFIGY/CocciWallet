//
//  EtherscanService.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import Foundation
import BigInt

public class Etherscan {
//
    private let API_KEY: String
    let session: URLSession
    let cache: (any Cache)?
    
    public init(
        api_key: String,
        session: URLSession = .shared,
        cache: (any Cache)? = nil
    ) {
        self.API_KEY = api_key
        self.session = session
        self.cache = cache
    }

    public func getTransactions(for address: String, explorer: String? = nil) async throws -> [Etherscan.Transaction] {
        
        let explorer = explorer ?? "etherscan.io"
        
        let key = "\(address)_\(explorer)_tx"
        if let item: [Transaction] = cache?.fetch(for: key) {
            print("Etherscan: \(item.count) TXs")
            return item
        }

//        let apiKey = API_KEY.isEmpty ? "" : "&apikey=\(API_KEY)"
        
        let base = "https://api.\(explorer)/api"

        let endpoint = base + "?module=account&action=txlist&address=\(address)&startblock=0&endblock=99999999&sort=desc"
        guard let url = URL(string: endpoint) else {return []}
        
        let (data, _) = try await session.data(from: url)
        
        let results = try JSONDecoder().decode(TransactionsResult.self, from: data)
        
        if let txs = results.result {
            cache?.store(txs, forKey: key, expiresIn: (1, .day))
            return txs
        } else {
            return []
        }
    }
    
    
    public enum Error: Swift.Error {
        case noApi, fetch, decode
    }
}


extension Etherscan {
    
    struct TransactionsResult: Decodable {
        public let status: String
        public let message: String
        public let result: [Etherscan.Transaction]?
    }

}
