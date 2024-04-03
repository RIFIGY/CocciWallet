//
//  TokenBalanceIntent.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import WidgetKit


struct NetworkBalanceIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Token"
    static var description = IntentDescription("Token Balance")
    
    @Parameter(title: "Wallet")
    var wallet: WalletEntity
    
    @Parameter(title: "Network")
    var network: NetworkEntity
    
    @Parameter(title: "Show Fiat", default: false)
    var showFiat: Bool
    
    @Parameter(title: "Currency", default: "usd")
    var currecny: String
    
    static var parameterSummary: some ParameterSummary {
        When(\.$showFiat, .equalTo, true) {
            Summary {
                \.$wallet
                \.$network
                \.$showFiat
                \.$currecny
            }
        } otherwise: {
            Summary {
                \.$wallet
                \.$network
                \.$showFiat
            }
        }
    }

}
