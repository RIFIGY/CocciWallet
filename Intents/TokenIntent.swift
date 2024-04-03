//
//  TokenIntent.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import WidgetKit
import OffChainKit

struct TokenIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Token"
    static var description = IntentDescription("Token Balance")
    
    @Parameter(title: "Wallet")
    var wallet: WalletEntity
    
    @Parameter(title: "Network")
    var network: NetworkEntity
    
    @Parameter(title: "Token", query: TokenQuery())
    var contract: ContractEntity
    
    @Parameter(title: "Currency", optionsProvider: CurrenciesProvider())
    var currency: String
    
    @Parameter(title: "Show Balance", default: true)
    var showBalance: Bool
        
    @Parameter(title: "Show in Price", default: false)
    var showFiat: Bool
    
    @Parameter(title: "Color Background", default: true)
    var showBackground: Bool


    static var parameterSummary: some ParameterSummary {
        When(\.$showBalance, .equalTo, true) {
            Summary {
                \.$wallet
                \.$network
                \.$contract
                \.$showBackground
                \.$currency
                \.$showBalance
                \.$showFiat
            }
        } otherwise: {
            Summary {
                \.$wallet
                \.$network
                \.$contract
                \.$showBackground
                \.$currency
                \.$showBalance

            }
        }
    }
    
    struct CurrenciesProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            CoinGecko.Currencies
        }
    }
}


