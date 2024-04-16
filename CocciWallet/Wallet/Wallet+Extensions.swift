//
//  Wallet.swift
//  CocciWallet
//
//  Created by Michael on 4/14/24.
//

import Foundation
import Web3Kit
import SwiftData

extension Wallet {
    public var address: EthereumAddress { .init(self.string) }
}

extension Wallet {
    
    @MainActor
    func updateCards(context: ModelContext) async {
        await withTaskGroup(of: Void.self) { group in
            networks.forEach { network in
                group.addTask { @MainActor in
                    guard network.needsUpdate() else {return}
                    do {
                        let context = self.modelContext ?? context
                        try await network.update(context: context)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
