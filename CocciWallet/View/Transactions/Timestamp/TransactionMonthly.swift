//
//  MonthlySection.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct MonthlySection<T:TransactionProtocol>: View {
    
    var months: [Int: [T] ]
    var title: String = "This Year"

    @Binding var selected: Int?
    
    var monthsSorted: [Int] {
        months.keys.sorted().reversed()
    }
    
    private let formatter = DateFormatter()
    
    
    var body: some View {
        TransactionSection(header: title) {
            ForEach(monthsSorted, id: \.self) { month in
                let transactions = months[month] ?? []
                let monthString = formatter.name(month: month)
                    VStack {
                        TransactionCellView(title: monthString, count: transactions.count, isCell: true)
                        if monthsSorted.last != month {
                            Divider().foregroundStyle(.secondary)
                                .padding(.vertical, 4)
                        }
                    }
                    .onTapGesture {
                        self.selected = month
                    }
                .foregroundStyle(.primary)
                
            }
        }

    }
}



extension DateFormatter {
    func name(month monthInt: Int) -> String {
        let monthIndex = monthInt - 1 // Adjust because arrays are zero-indexed
        if monthIndex >= 0 && monthIndex < self.monthSymbols.count {
            return self.monthSymbols[monthIndex]
        } else {
            return "Invalid month"
        }
    }
}

//#Preview {
//    MonthlySection<CocciWallet.Transaction>()
//        .environment(TransactionViewModel<CocciWallet.Transaction>.preview)
//}
