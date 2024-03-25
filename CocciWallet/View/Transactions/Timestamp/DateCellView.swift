//
//  DateCellView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct DateCellView: View {
    let title: String
    let subtitle: String
    var fromScroll = false
    
    var body: some View {
        HStack {
            TransactionIcon()
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            Spacer()
            if fromScroll {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
extension DateCellView {
    init(title: String, count: Int, fromScroll: Bool = false) {
        self.title = title
        self.subtitle = count.description + "Transactions"
        self.fromScroll = fromScroll
    }
}

#Preview {
    DateCellView(title: "Title", count: 8)
}
