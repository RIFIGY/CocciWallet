//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/28/24.
//

import Foundation
import web3


extension web3.EthereumHttpClient {
    internal func validate(_ address: String) throws -> EthereumAddress {
        guard let _ = address.web3.hexData else {
            throw EthereumClientError.noInputData
        }
        return .init(address)
    }
    
    internal func validate(_ block: Int?) -> EthereumBlock {
        if let block {
            return .init(rawValue: block)
        } else {
            return .Latest
        }
    }
}
