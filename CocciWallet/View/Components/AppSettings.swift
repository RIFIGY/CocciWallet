//
//  AppSettings.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/26/24.
//

import SwiftUI
import OffChainKit

struct AppSettings: View {
    
    var section: String?
    
    var body: some View {
        Section(section ?? "") {
            CurrencyCell()
            NetworkcardHeaderOption()
        }
        Section {
            IconCell(systemImage: "doc", color: .blue) {
                Text("Legal")
            }
            
            IconCell(systemImage: "hand.raised.fill", color: .blue) {
                Text("Privacy Policy")
            }
        } footer: {
            VStack {
                if let version {
                    Text("Version: " + version)
                }
                if let build {
                    Text("Build: " + build)
                }
            }
            .font(.caption)
            .frame(maxWidth: .infinity)
            .padding(.top)
        }
    }
    
    var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var build: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

}

struct NetworkcardHeaderOption: View {
    @AppStorage(AppStorageKeys.showNetworkPriceHeader) private var showPrice = true
    
    var body: some View {
        IconCell(systemImage: "info", color: .purple) {
            Text("Network Header")
            Spacer()
            Menu(showPrice ? "Price" : "Balance") {
                Button("Price") { showPrice = true }
                Button("Native Balance") { showPrice = false }
            }
        }
    }
}

struct CurrencyCell: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    @AppStorage(AppStorageKeys.lastSavedCoingeckoCurrencies) private var currencies: String = "usd,ils,jpy"

    func label(for code: String) -> String {
        if let symbol = getSymbol(for: code) {
            if symbol.count == 1 {
                symbol + " " + code
            } else {
                symbol
            }
        } else {
            code
        }
    }
    
    
    var body: some View {
        IconCell(systemImage: "coloncurrencysign", color: .green) {
            Text("Currency")
            Spacer()
            Menu(label(for: currency).uppercased()) {
                ForEach(CoinGecko.Currencies, id: \.self) { code in
                    Button{
                        add(currency: code)
                    } label: {
                        Text(label(for: code).uppercased())
                    }
                }
            }
        }
        
    }
    
    func getSymbol(for code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    func add(currency: String) {
        var currencies = self.currencies.components(separatedBy: ",")
        if !currencies.contains(currency) {
            currencies.append(currency)
        }
        self.currencies = currencies.joined(separator: ",")
        self.currency = currency
    }
}

#Preview {
    NavigationStack {
        Form {
            AppSettings()
        }
    }
}
