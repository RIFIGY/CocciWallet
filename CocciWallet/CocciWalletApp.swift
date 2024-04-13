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
        
        #if os(visionOS)
        WindowGroup(id: NFTWindow.ID) {
            NFTWindow()
        }
        .windowStyle(.plain)
        .defaultSize(.infinity)
        .modelContainer(WalletContainer.shared.container)
        #endif
//        #endif
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
