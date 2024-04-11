////
////  Tokens.swift
////  CocciWallet
////
////  Created by Michael on 4/8/24.
////
//
//import Foundation
//import Web3Kit
//import BigInt
//
//@Observable
//class Tokens: Codable {
//    var balances: [ERC20 : BigUInt] = [:]
//    var events: [ERC20Transfer] = []
//    
//
//    var contractInteractions: [EthereumAddress] {
//        Array(Set(events.map{$0.contract}))
//    }
//    
//    func fetch<C:ERC20Client>(address: Web3Kit.EthereumAddress, with client: C) async {
//        do {
//            let events = try await client.getTransferEvents(for: address)
//            print("\tERC20 - TXs: \(events.count.description), Tokens: \(contractInteractions.count.description)")
//            self.events = events
//            let balances = try await client.fetchBalances(for: address, in: contractInteractions)
//            balances.forEach { contract, balance in
//                self.balances[contract] = balance
//            }
//        } catch {
//            print("Tokkekn Error \(error) ")
//        }
//    }
//    
//    func value(contract: String, with priceModel: PriceModel, currency: String) -> Double? {
//        priceModel.price(contract: contract, currency: currency)
//    }
//    
//    func totalValue(chain: Int, _ priceModel: PriceModel, currency: String) -> Double {
//        balances.compactMap { contract, balance in
//            let value = balance.value(decimals: contract.decimals)
//            let price = priceModel.price(chain: chain, contract: contract.contract.string, currency: currency)
//            if let price {
//                return price * value
//            } else {
//                return 0
//            }
//        }
//        .reduce(0, +)
//    }
//}
//
//extension Tokens {
//    enum CodingKeys: String, CodingKey {
//        case _balances = "balances"
//    }
//}
//
