//
//  Wallet.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import Foundation
import Web3Kit

extension Wallet {
    public var address: EthereumAddress { .init(self.string) }
    
    public func update(with client: EthClient) async {
        
    }
}
