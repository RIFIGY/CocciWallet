//
//  SendViewModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/24/24.
//

import SwiftUI
import Web3Kit
import BigInt
import web3

@Observable
class SendViewModel {
    
//    let evm: Network
//    var address: String
//    let decimals: UInt8
    
    var amount: Double?
    
    var amountIsInCrypto = true
    

    var to: String = "0xBAa279516b206D56d555fb2e8dEfa1Bb3DDDdB93"

    var nonce = 0
    
    let gasLimit = BigUInt(6721975)
    var gasPrice: BigUInt?
    var estimatedGas: BigUInt?

    var txHash: String?
    
    var done = false
    

//    init(evm: Network, address: String, decimals: UInt8) {
//        self.evm = evm
//        self.address = address
//        self.decimals = decimals
//    }
    
    func fetchGas(client: EthereumClient) async {
        let gasPrice = try? await client.node.getGasPrice()
        withAnimation {
            self.gasPrice = gasPrice
        }
    }
    
    func fetchGasEstimate(from address: String, value: BigUInt?, client: EthereumClient, chain: Int) async {
        guard let value else {return}
        var transaction: EthereumTransaction { .init(
            from: .init(address),
            to: .init(to),
            value: value,
            data: nil,
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            chainId: chain
        )
        }
        do {
            let estimate = try await client.node.estimateGas(for: transaction)
            print("Estimate \(estimate)")
            withAnimation {
                self.estimatedGas = estimate
            }
        } catch {
            print("Estimate Error")
            print(error)
        }
    }
}
