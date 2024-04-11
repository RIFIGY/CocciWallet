//
//  AppStorage.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/25/24.
//

import SwiftUI

typealias AppStorageKeys = UserDefaults
extension AppStorageKeys {
    static var lastSelectedWallet: String { "last_selected_wallet" }
    static let lastSavedCoingeckoPlatforms = "last_saved_coingecko_platforms"
    static let lastSavedCoingeckoCoins = "last_saved_coingecko_coins"

    static let lastSavedCoingeckoCurrencies = "last_saved_coingecko_currencies"
    
    static let selectedCurrency = "selected_currency"
    static let showNetworkPriceHeader = "network_price_header"
    
//    static let allWallets = "wallet_keys"
    
    static let allWalletIDs = "wallet_ids"
    
    static let favoriteNFT = "favorite_nft"
    
    static func EVMs(address: String, custom: Bool) -> String {
        "\(address)_\(custom ? "custom_cards" : "cards")"
    }
}
