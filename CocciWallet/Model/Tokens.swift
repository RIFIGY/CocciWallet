//
//  TokensViewModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/26/24.
//

import Foundation
import Web3Kit
import BigInt
import ChainKit
 
@Observable
class TokenVM<Client:ERC20Client>: Codable {
        
    let address: String
    var balances: [ERC20 : BigUInt] = [:]
    var events: [ERC20Transfer] = []
    
    init(address: String) {
        self.address = address
    }
    
    
    func fetch(with client: Client) async {
        await fetchERC20Events(client)
        await fetchBalances(client)
    }
    
    var contractInteractions: [String] {
        Array(Set(events.map{$0.contract}))
    }
    
    var transfers: [ERC20 : [ERC20Transfer] ] {
        .init(grouping: events, by: { event in
            balances.keys.first{$0.contract.string.lowercased() == event.contract.lowercased()}!
        })
    }
    
    func totalValue(chain: Int, _ priceModel: PriceModel, currency: String) -> Double {
        balances.compactMap { contract, balance in
            let value = balance.value(decimals: contract.decimals)
            let price = priceModel.price(chain: chain, contract: contract.contract.string, currency: currency)
            if let price {
                return price * value
            } else {
                return 0
            }
        }
        .reduce(0, +)
    }
    
}

extension TokenVM {
    
    private func fetchBalances(_ client: Client) async {
        do {
            let balances = try await client.fetchBalances(for: address, in: self.contractInteractions)
            balances.forEach { contract, balance in
                self.balances[contract] = balance
            }
        } catch {
            print(error)
        }

    }
    
    
    private func fetchERC20Events(_ client: Client) async {
        do {
            let events = try await client.getTransferEvents(for: address)
            self.events = events
            print("\tERC20 - TXs: \(events.count.description), Tokens: \(contractInteractions.count.description)")
        } catch {
            print(error)
        }
    }
    

    
}

extension TokenVM {
//    func totalValue(in evm: EVM, _ priceModel: PriceModel, currency: String) -> Double {
//        balances.compactMap { contract, balance in
//            let value = balance.value(decimals: contract.decimals)
////            let price = priceModel.price(evm: evm, contract: contract.contract, currency: currency)
////            if let price {
////                return price * value
////            } else {
////                return nil
////            }
//            return value
//        }
//        .reduce(0, +)
//    }
    

    

}

extension TokenVM {
    enum CodingKeys: String, CodingKey {
        case _balances = "balances"
        case address = "address"
    }
}
