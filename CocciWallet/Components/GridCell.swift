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
    var action: (() -> Void)? = nil
    
    var body: some View {
        if let action {
            content
                .targetable()
                .onTapGesture(perform: action)
        } else {
            content
        }
    }
    
    var content: some View {
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
        .cellBackground(padding: 8, cornerRadius: 16)
    }
    struct Button: View {
        let title: String
        let systemName: String
        var size: CGFloat = 164
        var action: (() -> Void)? = nil

        
        var body: some View {
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
            .foregroundStyle(.primary)
            .cellBackground(padding: 16, cornerRadius: 16)
            .optional(action) { view, action in
                view
                .targetable()
                .onTapGesture(perform: action)
            }
        }
    }
}

extension GridCell {
    init(title: String, balance: Double?, value: Double?, currency: String = "usd") {
        self.title = title
        self.detail = balance?.string(decimals: 5) ?? "--"
        self.value = value?.formatted(.currency(code: currency))
    }
    
    init(_ destination: NetworkCardDestination, balance: Double?, value: Double?, currency: String = "usd") {
        self.title = destination.rawValue.capitalized
        self.detail = balance?.string(decimals: 5) ?? "--"
        self.value = value?.formatted(.currency(code: currency))
    }
}

extension GridCell.Button {
    init(_ destination: NetworkCardDestination, size: CGFloat = 164) {
        self.title = destination.rawValue.capitalized
        self.systemName = destination.systemName
    }
}

enum NetworkCardDestination: String, CaseIterable {
    case send, receive, stake, swap, nft, tokens, balance
    
    var systemName: String {
        switch self {
        case .receive:
            "arrow.down"
        case .send:
            "arrow.up"
        case .stake:
            "banknote"
        case .swap:
            "rectangle.2.swap"
        default: "circle"
        }
    }
}

#Preview {
    GridCell(title: "Title", balance: 100, value: 4324)
}
