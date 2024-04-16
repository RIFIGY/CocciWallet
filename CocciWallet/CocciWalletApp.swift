//
//  CocciWalletApp.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import SwiftData

@main
struct CocciWalletApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()

        }
        .windowResizability(.contentSize)
        .modelContainer(sharedModelContainer)
        
        WindowGroup(id: NFTWindow.ID, for: NFTEntity.self) { $entity in
            NFTWindow(nft: $entity)
        } defaultValue: {
            NFTEntity(tokenId: "0", contract: "", uri: nil, metadata: nil)
        }
        #if os(visionOS)
        .windowStyle(.plain)
        .defaultSize(.infinity)
        #endif
        .modelContainer(sharedModelContainer)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
