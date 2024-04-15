//
//  ColorTheme.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/2/24.
//

import SwiftUI

public struct NetworkTheme: Hashable, Equatable, Codable {
        
    let symbol: String
    let color: Color
    let decimals: UInt8
}

private struct NetworkThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue = NetworkTheme(symbol: "ETH", color: .ETH, decimals: 18)
}

extension EnvironmentValues {
  var networkTheme: NetworkTheme {
    get { self[NetworkThemeEnvironmentKey.self] }
    set { self[NetworkThemeEnvironmentKey.self] = newValue }
  }
}

private struct NetworkColorModifier: ViewModifier {
    @Environment(\.networkTheme) private var theme

    func body(content: Content) -> some View {
        content
            .foregroundStyle(theme.color)

    }
}

extension View {
    
    func networkColor() -> some View {
        self.modifier(NetworkColorModifier())
    }
    
    func networkTheme(symbol: String, color: Color, decimals: UInt8) -> some View {
        self.environment(\.networkTheme, .init(
            symbol: symbol,
            color: color,
            decimals: decimals
        ))
  }

    func networkTheme(card: Network) -> some View {
        self.environment(\.networkTheme, .init(
            symbol: card.symbol,
            color: card.color,
            decimals: card.decimals
        ))
    }
    
    

}

#if canImport(Web3Kit)
import ChainKit
import OffChainKit
extension View {
    
    @ViewBuilder
    func networkTheme(token: any Contract, networkColor: Color) -> some View {
        var color: Color? {
            guard !token.symbol.isEmpty, let color = Icon(symbol: token.symbol)?.color
            else {return nil}
            return color
        }
        self.environment(\.networkTheme, .init(
            symbol: token.symbol,
            color: color ?? networkColor,
            decimals: token.decimals ?? 18
        ))
    }
}
#endif
