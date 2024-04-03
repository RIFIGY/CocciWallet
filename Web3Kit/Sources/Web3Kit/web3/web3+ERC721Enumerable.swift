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
    
    public func totalSupply(contract: String) async throws -> BigUInt {
        return try await enumerable.totalSupply(contract: try validate(contract))

    }
    
    
//    public func getERC721TokenIds(contract: String) async throws -> [BigUInt] {
//        let contract = try validate(contract)
//        let total = try await enumerable.totalSupply(contract: contract)
//        
//        return await withTaskGroup(of: BigUInt?.self) { group in
//            for index in 0..<total {
//                group.addTask {
//                    try? await self.enumerable.tokenByIndex(contract: contract, index: index)
//                }
//            }
//            
//            return await group.reduce(into: [BigUInt]()) { partialResult, result in
//                if let result {
//                    partialResult.append(result)
//                }
//            }
//        }
//    }

}
