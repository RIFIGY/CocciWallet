//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import BigInt
import Logging
import web3

open class EthereumClient<C:EthereumClientProtocol> {
    public typealias Account = C.Account
    public typealias Client = C
    public let node: Client
    public let chain: Int
    public let rpc: URL
    
    public init(client: Client, chain: Int, rpc: URL) {
        self.node = client
        self.chain = chain
        self.rpc = rpc
    }
    
    public enum Error: Swift.Error {
        case badType
    }
}

public class EthClient: EthereumClient<EthereumHttpClient> {
    
}

extension EthereumClient where C == EthereumHttpClient {
    public convenience init(rpc: URL, chain: Int, logger: Logger? = nil) {
        let client = EthereumHttpClient(url: rpc, logger: logger, network: .custom(chain.description) )
        self.init(client: client, chain: chain, rpc: rpc)
    }
}
