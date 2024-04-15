// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        PrivateKeyWallet.self, Network.self, Token.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
