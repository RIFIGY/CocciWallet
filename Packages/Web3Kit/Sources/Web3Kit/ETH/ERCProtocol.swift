//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/12/24.
//

import Foundation

public protocol ERC: Identifiable, Codable, Equatable, Hashable {
    var contract: String {get}
    var name: String? {get}
    var symbol: String? {get}
}

extension ERC {
    public var id: String { contract }
}

