//
//  SwiftUIView.swift
//  
//
//  Created by Michael Wilkowski on 3/16/24.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func conditional<Content: View>(_ condition: Bool, modifier: @escaping (Self) -> Content) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func optional<Item: Any>(_ optional: Item?, modifier: @escaping (Self, Item) -> some View) -> some View {
        if let optional {
            modifier(self, optional)
        } else {
            self
        }
    }
    
}
