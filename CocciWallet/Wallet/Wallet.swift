//
//  Wallet.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import Foundation
import Web3Kit

typealias Wallet = PrivateKeyWallet

extension Wallet {
    public var address: EthereumAddress { .init(self.id) }
}
