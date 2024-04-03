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
    
    static func copy(_ string: String) {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents() // Recommended to clear the pasteboard first
        pasteboard.setString(string, forType: .string)
        #else
        UIPasteboard.general.string = string
        #endif
    }
}

