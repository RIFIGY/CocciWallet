//
//  Tokens+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/29/24.
//

import Foundation
import Web3Kit

extension EthClient {
    static let local: EthClient = .init(rpc: URL(string: "HTTP://127.0.0.1:7545")!, chain: 1337)
}

extension TokenVM where Client == EthClient.Client {
    
    static let preview: TokenVM<EthClient.Client> = .init(address: Wallet.rifigy.address)
    
}

extension ContractEntity {
    static let usdc = ContractEntity(contract: ERC20.USDC.contract, name: ERC20.USDC.name!, symbol: ERC20.USDC.symbol)
}

