// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import web3

public extension String {
    var isEthereumAddress: Bool {
        self.web3.isAddress
    }
}
