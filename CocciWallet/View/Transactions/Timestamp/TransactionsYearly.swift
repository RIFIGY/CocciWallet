//
//  YearlySection.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI

struct YearlySection<T:TransactionProtocol>: View {
    
    let previousYears: [Int: [T]]
    
    var previousYearsSorted: [Int] {
        previousYears.keys.sorted().reversed()
    }
    
    @Binding var selected: Int?
    
    private let formatter = DateFormatter()
    
    var body: some View {
        TransactionSection(header: "Previous Years") {
            VStack {
                ForEach(previousYearsSorted, id: \.self) { year in
                    VStack {
                        TransactionCellView(
                            title: year.description,
                            count: previousYears[year]?.count ?? 0,
                            isCell: true
                        )
                        if previousYearsSorted.last != year {
                            Rectangle().frame(height: 1).foregroundStyle(.secondary)
                        }
                    }
                    .onTapGesture {
                        self.selected = year
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }

}


//import Web3Kit
//#Preview {
//    YearlySection<CocciWallet.Transaction>()
//        .environment(TransactionViewModel<CocciWallet.Transaction>.preview )
//}
