//
//  NavigationBackButton+Extension.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 4/3/24.
//

import UIKit
import SwiftUI
//extension UINavigationController {
//    open override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        navigationBar.isHidden = true
//    }
//}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}


struct NavigationBackViewModifier<C:View>: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    @ViewBuilder
    var item: C
    
    func body(content: Content) -> some View {
        content
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    item
                }
            }
        }
        
    }
}

extension View {
    func navigationBarBackButton<C:View>(@ViewBuilder button: () -> C ) -> some View {
        self
        .modifier(NavigationBackViewModifier(item: button ) )
    }
    
    func navigationBarBackButton(_ title: String?) -> some View {
        self
        .modifier(
            NavigationBackViewModifier{
                HStack(spacing: 4){
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                    Text(title ?? "Back")
                }
            }
        )
    }
    
    func navigationBarBackButton(_ title: String?, color: Color) -> some View {
        self
        .modifier(
            NavigationBackViewModifier{
                HStack(spacing: 4){
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                    Text(title ?? "Back")
                }
                .foregroundStyle(color)
            }
        )
    }
}
