//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/24/24.
//

import Foundation
import web3
import BigInt

extension ERC721MetadataFunctions {
    public struct baseURI: ABIFunction {
        public static let name = "baseURI"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        // Initialization remains largely the same as your `name` function,
        // since it primarily sets up transaction parameters and the contract address.
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            // No parameters to encode for a simple getter function.
        }
    }
}
extension ERC721MetadataResponses {
    public struct baseURIResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [URL.self]

        public let value: URL

        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
}


public extension web3.ERC721Metadata {
    func baseURI(contract: EthereumAddress) async throws -> URL {
        let function = ERC721MetadataFunctions.baseURI(contract: contract)
        let data = try await function.call(withClient: client, responseType: ERC721MetadataResponses.baseURIResponse.self)

        return data.value
    }
}
