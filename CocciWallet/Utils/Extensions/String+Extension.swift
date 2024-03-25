//
//  String+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/5/24.
//

import SwiftUI

extension String {
    func shortened(_ start: Int = 5, _ end: Int = 5) -> String {
        guard self.count > start + end + 3 else { return self }
        
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.endIndex, offsetBy: -end)
        let firstPart = self[..<startIndex]
        let lastPart = self[endIndex...]
        
        return "\(firstPart)...\(lastPart)"
    }
}

func printPrettyJSON(_ data: Data) {
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        if let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
            print(prettyPrintedString)
        } else {
            print("Failed to convert to pretty JSON")
        }
    } catch {
        print("Failed to convert to pretty JSON: \(error.localizedDescription)")
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
