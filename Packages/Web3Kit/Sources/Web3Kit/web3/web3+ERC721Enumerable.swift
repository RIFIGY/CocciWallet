//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/28/24.
//

import Foundation
import web3
import BigInt

extension EthereumHttpClient {
    
    private var enumerable: web3.ERC721Enumerable { .init(client: self) }
    
    public func totalSupply(contract: EthereumAddress) async throws -> BigUInt {
        return try await enumerable.totalSupply(contract: contract)

    }
}
