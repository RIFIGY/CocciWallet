//
//  CocciWalletApp.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import SwiftData
import WalletData

@main
struct CocciWalletApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        .modelContainer(WalletContainer.shared.container)
        
        WindowGroup(id: NFTWindow.ID) {
            NFTWindow()
        }
        #if os(visionOS)
        .windowStyle(.plain)
        .defaultSize(.infinity)
        #endif
        .modelContainer(WalletContainer.shared.container)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
