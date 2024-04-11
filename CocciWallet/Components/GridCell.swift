//
//  GridCell.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/29/24.
//

import SwiftUI

struct GridCell: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let detail: String?
    let value: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                if let detail {
                    Text(detail)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .font(.title.weight(.bold))
                        .networkColor()
                }
                Text(value ?? "--")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 8)
//        .padding(.vertical, 8)
        .cellBackground(padding: 8, cornerRadius: 16)

    }
    struct Button: View {
        let title: String
        let systemName: String
//        let color: Color
        var size: CGFloat = 164
        var action: () -> Void
    
        
        var body: some View {
            SwiftUI.Button {
                action()
            } label: {
                HStack {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size/5, height: size/5)
                        .networkColor()

                    Text(title)
                        .font(.title3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .fontWeight(.semibold)
            }
            .foregroundStyle(.primary)
            .cellBackground(padding: 16, cornerRadius: 16)
        }
    }
}

extension GridCell {
    init(title: String, balance: Double?, value: Double?, currency: String = "usd") {
        self.title = title
        self.detail = balance?.string(decimals: 5) ?? "--"
        self.value = value?.formatted(.currency(code: currency))
    }
}


#Preview {
    GridCell(title: "Title", balance: 100, value: 4324)
}
