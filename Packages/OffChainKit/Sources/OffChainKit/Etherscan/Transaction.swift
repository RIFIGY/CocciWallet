//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/26/24.
//

import Foundation

public extension Etherscan {
    struct Transaction: Codable {
        public let to: String
        public let from: String?
        public let value: String?
        
        public let blockNumber, timeStamp, hash, nonce: String
        public let blockHash, transactionIndex: String
        public let gas, gasPrice, gasUsed, cumulativeGasUsed, isError: String
        public let txreceiptStatus, input, contractAddress: String?
        public let confirmations, methodID, functionName: String?
        
    }

}
public extension Etherscan.Transaction {
    
    var functionType: String {
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
    
    var title: String {
        guard functionType.isEmpty else {return functionType}
        if let value, let intValue = Int(value), intValue > 0 {
            return "Transfer"
        } else {
            return "Interaction"
        }
    }
    
    var date: Date {
        let timestamp = Double(timeStamp)!
        return Date(timeIntervalSince1970: timestamp)
    }
}
