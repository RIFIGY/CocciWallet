//
//  TransactionView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/19/24.
//

import SwiftUI
import OffChainKit

struct TransactionIcon<I:View>: View {
    var color: Color = .black
    var size: CGFloat = 24
    var padding: CGFloat? = nil
    
    @ViewBuilder
    var content: I
    
    var body: some View {
        RoundedView(color: color, foreground: .white, size: size, padding: padding) {
            content
        }
    }
}

struct TransactionCellView<I:View>: View {
    @AppStorage(AppStorageKeys.selectedCurrency) private var currency: String = "usd"
    
    let title: String
    var subtitle: String?
    var caption: String?
    
    var value: String?
    var detail: String?
        
    var isCell = true
    
    let icon: I
    
    
    var body: some View {
        HStack(alignment: .center) {
            icon
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Group {
                        if let caption, let subtitle {
                            Text(caption)
                                .font(.caption)
                            Text(subtitle)
                                .font(.footnote)
                        } else if let caption {
                            Text(caption)
                        } else if let subtitle {
                            Text(subtitle)
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(alignment: .top){
                    VStack(alignment: .trailing, spacing: 2) {
                        if let value {
                            Text(value)
                            if let detail {
                                Text(detail)
                                    .padding(4)
                                    .background(Color.systemGray)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .cornerRadius(6)
                            }
                        }
                    }
                    if isCell {
                        Image(systemName: "chevron.right")
                            .fontWeight(.thin)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}


// Image
extension TransactionCellView {
    
    //MARK: - SystemImage
    init(
        title: String,
        systemName: String = "list.bullet",
        color: Color? = nil,
        subtitle: String? = nil,
        caption: String? = nil,
        value: String? = nil,
        detail: String? = nil,
        isCell: Bool = true
    ) where I == TransactionIcon<Image> {
        self.title = title
        self.subtitle = subtitle
        self.caption = caption
        self.value = value
        self.detail = detail
        self.isCell = isCell
        if let color {
            self.icon = TransactionIcon(systemImage: systemName, color: color)
        } else {
            self.icon = TransactionIcon(systemImage: systemName)
        }
    }

    // MARK: Transaction Count
    init(
        title: String,
        count: Int,
        isCell: Bool = false
    ) where I == TransactionIcon<Image> {
        self.title = title
        self.subtitle = "\(count) Transaction\(count >= 2 ? "s":"")"
        self.isCell = isCell
        self.icon = TransactionIcon()
    }

    // MARK; - TX Protocol
    init<P:TransactionProtocol>(
        tx: P,
        symbol: String?,
        decimals: UInt8 = 18,
        fallback: Color = .app,
        isCell: Bool = true
    ) where I == TransactionIcon<IconView> {
        self.title = tx.title
        self.subtitle = tx.timestamp?.formatted(date: .numeric, time: .omitted)
        self.caption = tx.toAddressString; #warning("fix this")
        self.isCell = isCell
        if let amount = tx.amount {
            self.value = amount.formatted(.number)
        } else if let value = tx.bigValue {
            self.value = value.formatted(.crypto(decimals: decimals, precision: 4))
        }
        
        self.icon = TransactionIcon(symbol: symbol, fallback: fallback)

    }
}

extension TransactionIcon {
    init(
        systemImage: String = "list.bullet",
        color: Color = .black, 
        size: CGFloat = 24,
        padding: CGFloat? = nil) where I == Image {
        self.color = color
        self.size = size
        self.padding = padding
        self.content = Image(systemName: systemImage).resizable()
    }
    
    init(
        symbol: String?, 
        fallback: Color = .app,
        size: CGFloat = 24,
        padding: CGFloat? = nil
    ) where I == IconView {
        let icon = Icon(symbol: symbol)
        self.color = icon?.color ?? fallback
        self.size = size
        self.padding = padding
        self.content = IconView(symbol: symbol, size: size + 6 , glyph: .white, fallback: fallback)
    }
}

#Preview {
    TransactionIcon(symbol: nil)
}


#Preview {
    TransactionCellView(tx: Transaction.preview, symbol: "ETH")
        .padding()
}

#Preview {
    List {
//        TransactionCellView(title: "Title", date: .now, amount: 135.42, price: 100, currency: "usd", addresses: (Wallet.rifigy.address, Wallet.wallet.address))

        TransactionCellView(tx: Transaction.preview, symbol: "ETH")
        TransactionCellView(title: "Title", systemName: "circle", color: .indigo)

        TransactionCellView(title: "Title", count: 42)

    }

}
