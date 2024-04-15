//
//  Entity+Preview.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import Foundation
import Web3Kit

extension WalletEntity {
    static let rifigy = WalletEntity(name: "Rifigy", address: Wallet.rifigy.address.string)
    static let wallet = WalletEntity(name: Wallet.wallet.name, address: Wallet.wallet.address.string)
    static let dave = WalletEntity(name: Wallet.dave.name, address: Wallet.dave.address.string)
    static let ganache = WalletEntity(name: Wallet.ganache.name, address: Wallet.ganache.address.string)

}

extension ContractEntity {
    static let munko = ContractEntity(address: ERC721.Munko.contract.string, name: ERC721.Munko.name, symbol: ERC721.Munko.symbol, decimals: nil)
    static let usdc = ContractEntity(address: ERC20.USDC.contract.string, name: ERC20.USDC.name, symbol: ERC20.USDC.symbol, decimals: ERC20.USDC.decimals)

}

//extension NetworkEntity {
//    static let preview = NetworkEntity(
//        address: EthereumAddress.rifigy.string,
//        chain: 1,
//        rpc: <#T##URL#>,
//        name: <#T##String#>,
//        hexColor: <#T##String#>,
//        coin: <#T##String#>,
//        symbol: <#T##String#>,
//        decimals: <#T##UInt8#>)
//    static let ETH = NetworkEntity(id: EthereumCardEntity.ETH.chain.description, title: EthereumCardEntity.ETH.name, symbol: EthereumCardEntity.ETH.symbol)
//}
