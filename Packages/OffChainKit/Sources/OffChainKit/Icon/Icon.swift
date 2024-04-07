//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/25/24.
//

import SwiftUI

public struct Icon: Codable {
    public let symbol: String
    public let name: String
    public let hexColor: String
    
    public var color: Color {
        Color(hex: hexColor) ?? .red
    }
    
    enum CodingKeys: String, CodingKey {
        case symbol, name
        case hexColor = "color"
    }
}

public enum IconType: String, CaseIterable {
    case black, white, color, icon
}
extension Icon {
    public init?(_ symbol: String?) {
        guard let symbol = symbol,
              let icon = Self.all.first(where: {$0.symbol.lowercased() == symbol.lowercased()})
        else {return nil}
        self = icon
    }
    public init?(symbol: String?) {
        guard let symbol = symbol,
              let icon = Self.all.first(where: {$0.symbol.lowercased() == symbol.lowercased()})
        else {return nil}
        self = icon
    }
    
    static fileprivate let all: [Icon] = {
        guard let bundlePath = Bundle.module.url(forResource: "icons", withExtension: "json") else {
            return []
        }
        if let data = try? Data(contentsOf: bundlePath),
           let icons = try? JSONDecoder().decode([Icon].self, from: data) {
            return icons
        } else {
            return []
        }
    }()
}


//extension Icon {
//    // Change the storage from an array to a dictionary for efficient lookups.
//    static let all: [String: Icon] = {
//        var iconsDictionary = [String: Icon]()
//        
//        guard let bundlePath = Bundle.module.url(forResource: "icons", withExtension: "json"),
//              let data = try? Data(contentsOf: bundlePath),
//              let icons = try? JSONDecoder().decode([Icon].self, from: data) else {
//            return [:]
//        }
//        
//        // Populate the dictionary
//        icons.forEach { icon in
//            iconsDictionary[icon.symbol.lowercased()] = icon
//        }
//        
//        return iconsDictionary
//    }()
//    
//    public init?(symbol: String?) {
//        guard let symbol = symbol?.lowercased(),
//              let icon = Self.all[symbol] else {
//            return nil
//        }
//        self = icon
//    }
//}
