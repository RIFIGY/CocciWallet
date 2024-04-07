//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI

#if os(macOS)
typealias SystemColor = NSColor
#else
typealias SystemColor = UIColor
#endif

public extension Color {

    init(hex: UInt64, alpha: CGFloat = 1) {
        let color = SystemColor(hex: hex, alpha: alpha)
        self.init(color)
    }

    init?(hex: String, alpha: CGFloat = 1) {
        guard let color = SystemColor(hex: hex, alpha: alpha)
        else { return nil }
        self.init(color)
    }
    
    var hexString: String? {
        guard let components = self.cgColor?.components, components.count >= 3 else {
            return nil
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count > 3 ? components[3] : 1.0
        return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(red) * 255), lroundf(Float(green) * 255), lroundf(Float(blue) * 255), lroundf(Float(alpha) * 255))
    }
}

extension SystemColor {

    convenience init(hex: UInt64, alpha: CGFloat = 1) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    convenience init?(hex: String, alpha: CGFloat = 1) {
        let hex = hex.cleanedForHex()
        guard hex.conforms(to: "[a-fA-F0-9]+") else { return nil }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        self.init(hex: hexNumber, alpha: alpha)
    }
    

}

private extension String {

    func cleanedForHex() -> String {
        if hasPrefix("0x") {
            return String(dropFirst(2))
        }
        if hasPrefix("#") {
            return String(dropFirst(1))
        }
        return self
    }

    func conforms(to pattern: String) -> Bool {
        let pattern = NSPredicate(format:"SELF MATCHES %@", pattern)
        return pattern.evaluate(with: self)
    }
}

extension Color: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hex = try container.decode(String.self, forKey: .hex)
        if let color = Color(hex: hex) {
            self = color
        } else {
            throw Error.decode
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        guard let hex = self.hexString else {return}
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hex, forKey: .hex)

    }
    
    enum CodingKeys: String, CodingKey {
        case hex
    }
    enum Error: Swift.Error { case decode }
}
