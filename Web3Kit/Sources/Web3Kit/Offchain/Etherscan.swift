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
    private let base = "https://api.polygonscan.com/api"
    let session: URLSession
    let cache: (any Web3Kit.Cache)?
    
    public init(
        api_key: String,
        session: URLSession = .shared,
        cache: (any Web3Kit.Cache)? = nil
    ) {
        self.API_KEY = api_key
        self.session = session
        self.cache = cache
    }

    
    public func getTransactions(for address: String, evm: EVM) async throws -> [Transaction] {
        guard let base = evm.explorer else { throw Error.noApi }
        return try await getTransactions(for: address, base: base)
    }
    
    public func getTransactions(for address: String, base: String) async throws -> [Transaction] {
        
        let key = "\(address)_\(base)_tx"
        if let item: [Transaction] = cache?.fetch(for: key) {
            return item
        }

        var apiKey: String {
            if API_KEY.isEmpty {
                ""
            } else {
//                "&apikey=\(API_KEY)"
                ""
            }
        }
        
        let base = "https://api.\(base)/api"

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
    
    public struct TransactionStore: Codable {
        let address: String
        var lastUpdated = Date()
        var transactions: [Transaction]
    }
    
    public enum Error: Swift.Error {
        case noApi, fetch, decode
    }
}


public extension Etherscan {
    
    struct TransactionsResult: Decodable {
        public let status: String
        public let message: String
        public let result: [Etherscan.Transaction]?
    }
    
    struct Transaction: Codable {
        public let to: String
        public let from: String?
        public let value: String?
        
        public let blockNumber, timeStamp, hash, nonce: String
        public let blockHash, transactionIndex: String
        public let gas, gasPrice, gasUsed, cumulativeGasUsed, isError: String
        public let txreceiptStatus, input, contractAddress: String?
        public let confirmations, methodID, functionName: String?
        
        public var functionType: String {
            guard let functionName else {return ""}
                // Extract function name by finding substring up to the "("
            guard let endIndex = functionName.firstIndex(of: "(") else { return functionName }
            let functionType = String(functionName[..<endIndex])

            // Split the functionName by camel case
            var words = [String]()
            var currentWord = ""

            for character in functionType {
                if character.isUppercase && !currentWord.isEmpty {
                    // If character is uppercase and it's not the start of the string, start a new word
                    words.append(currentWord)
                    currentWord = ""
                }
                currentWord.append(character)
            }
            words.append(currentWord.capitalized) // Add the last word

            // Combine words with a space or any other separator
            return words.joined(separator: " ").capitalized
        }
    }

}

extension Etherscan.Transaction: EthereumTransfer {
    
    public var sorter: Date {
        let timestamp = Double(timeStamp)!
        return Date(timeIntervalSince1970: timestamp)
    }
    public var fromAddress: String {
        self.from ?? ""
    }
    
    public var toAddress: String {
        self.to
    }
    public var bigValue: BigUInt? {
        if let value {
            return .init(stringLiteral: value)
        } else {return nil}
    }
    
    public var id: String {hash}
}

public extension Etherscan.Transaction {
    var toAddressString: String {
        to
    }
    
    var fromAddressString: String {
        from ?? ""
    }
    
    var title: String {
        guard functionType.isEmpty else {return functionType}
        if let bigValue, bigValue > 0 {
            return "Transfer"
        } else {
            return "Interaction"
        }
    }
    
    var subtitle: String {
        to
    }

    
    var amount: Double? {
        bigValue?.value(decimals: 18)
    }
    
    var date: Date {
        let timestamp = Double(timeStamp)!
        return Date(timeIntervalSince1970: timestamp)

    }
}
extension BigUInt {
    func value(decimals: UInt8) -> Double {
        let balanceInWei = Decimal(string: self.description) ?? Decimal.zero
        let weiToTokenDivisor: BigUInt = BigUInt(10).power(Int(decimals))
        let divisor = Decimal(string: weiToTokenDivisor.description)!

        let balanceInTokenDecimal = balanceInWei / divisor
        return NSDecimalNumber(decimal: balanceInTokenDecimal).doubleValue
    }
}
