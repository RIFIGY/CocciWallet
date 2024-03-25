//
//  Theme.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI

public enum Theme: Hashable, Equatable {
    
    case auto, color(Color), auto_color, dark, light
    
    var title: String {
        switch self {
        case .auto:
            "Auto"
        case .color(let color):
            color.description
        case .auto_color:
            "Auto Color"
        case .dark:
            "Dark"
        case .light:
            "Light"
        }
    }
}

public extension View {
    @ViewBuilder
    func theme(_ theme: Theme, autoColor: Color? = nil) -> some View {
        switch theme {
        case .auto:
            self
        case .color(let color):
            self.background(color)
        case .auto_color:
            self
        case .dark:
            self.preferredColorScheme(.dark)
        case .light:
            self.preferredColorScheme(.light)
        }
    }
}

private struct ThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue = Theme.auto_color
}

extension EnvironmentValues {
  var theme: Theme {
    get { self[ThemeEnvironmentKey.self] }
    set { self[ThemeEnvironmentKey.self] = newValue }
  }
}
