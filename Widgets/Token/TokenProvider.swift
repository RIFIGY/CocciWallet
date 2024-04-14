//
//  TokenProvider.swift
//  WidgetsExtension
//
//  Created by Michael Wilkowski on 3/30/24.
//

import WidgetKit
import OffChainKit
import WalletData

struct TokenEntry: TimelineEntry {
    let date: Date
    let intent: TokenIntent
    var balance: Double?
    var price: Double?
    var error: String?
}

fileprivate extension TokenIntent {
    static var placeholder: TokenIntent {
        let intent = TokenIntent()
//        let storage = Storage.shared
//        let wallets: [WalletEntity] = storage.wallets()
//        guard let wallet = wallets.first else {return intent}
//        
//        intent.wallet = wallet
////        if let network = storage.networks(for: wallet.id).first(where: {!$0.tokenInfo.balances.isEmpty}) {
////            intent.network = NetworkEntity(card: network)
////            if let contract = storage.tokenContracts(for: wallet.id, in: network.id).first {
////                let entity = ContractEntity(contract: contract )
////                intent.contract = entity
////            }
////        }
        return intent
    }
}

struct TokenProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TokenEntry {
        TokenEntry(date: .now, intent: .placeholder)
    }
    
    func snapshot(for intent: TokenIntent, in context: Context) async -> TokenEntry {
        TokenEntry(date: .now, intent: intent)
    }
    
    func timeline(for intent: TokenIntent, in context: Context) async -> Timeline<TokenEntry> {
        
        let balance = await WalletContainer.shared.fetchBalance(
            wallet: intent.wallet.id,
            networkID: intent.network.id,
            contract: intent.contract.address
        )
        #warning("fix this")
        var entry = TokenEntry(date: .now, intent: intent, balance: balance)
        
        do {
            let currentPrice = try await fetchPrice(network: intent.network, contract: intent.contract, currency: intent.currency)
            entry.price = currentPrice
        } catch {
            entry.error = error.localizedDescription
        }

        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    private let api = CoinGecko.shared
    
    private func fetchPrice(network: NetworkEntity, contract entity: ContractEntity, currency: String) async throws -> Double {
        let chain = Int(network.id)
        let contract = entity.address
        guard let chain, let platform = CoinGecko.AssetPlatform.NativeCoin(chainID: chain) else {
            throw NSError(domain: "CoinGeckoWidget", code: 2, userInfo: [NSLocalizedDescriptionKey: "No Native Platform ID"])
        }
        
        do {
            return try await api.fetchPrice(platform: platform, contract: contract, currency: currency)
        } catch {
            throw NSError(domain: "CoinGeckoWidget", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error Fetching Price"])
        }
        
    }
}
