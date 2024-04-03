//
//  Array+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/1/24.
//

import Foundation

//extension Array where Element:Equatable {
//    mutating func remove(_ element: Element) {
//        guard let index = self.firstIndex(where: {$0 == element}) else {return}
//        self.remove(at: index)
//    }
//}

extension Array where Element:Identifiable {
    mutating func remove(_ element: Element) {
        guard let index = self.firstIndex(where: {$0.id == element.id}) else {return}
        self.remove(at: index)
    }
}
