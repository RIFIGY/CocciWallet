//
//  Pasteboard.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/25/24.
//

import SwiftUI

enum Pasteboard {
    static func paste() -> String? {
        #if os(macOS)
        NSPasteboard.general.string(forType: .string)
        #else
         UIPasteboard.general.string
        #endif
    }
}

