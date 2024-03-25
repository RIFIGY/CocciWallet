//
//  TestConfig.swift
//  CocciWalletTests
//
//  Created by Michael Wilkowski on 3/23/24.
//

import Foundation

struct TestConfig {
    static let localPort = 7575
    static let localChain = 1337

    static let localRPC = URL(string:"http://127.0.0.1:\(localPort)")!
    static let ipRPC = URL(string: "http://10.0.0.11:\(localPort)")!
    
}
