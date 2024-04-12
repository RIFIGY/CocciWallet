//
//  Tokens+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/29/24.
//

import Foundation
import Web3Kit
import ChainKit

extension EthereumClient {
    static let local: Web3Kit.EthereumClient = .init(rpc: URL(string: "HTTP://127.0.0.1:7545")!, chain: 1337)
}


