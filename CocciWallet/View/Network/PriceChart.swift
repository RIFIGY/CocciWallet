//
//  PriceChart.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import SwiftUI
import Charts
import Web3Kit
import OffChainKit

struct PriceChart: View {
    @Environment(PriceModel.self) private var priceModel
    
    let evm: EVM
    
    var contract: String? = nil
    var full: Bool = false
    
    var coingeckoId: String? {
        CoinGecko.AssetPlatform.NativeCoin(chainID: evm.chain)
    }

    var prices: CoinGecko.PriceHistory? {
        nil
//        priceModel.priceHistory[coingeckoId ?? ""]
    }

    var priceArray: [CoinGecko.PriceHistory.Price] {
        (prices?.prices ?? []).sorted{ $0.date > $1.date }
    }
    
    
    var minY: Double {
        priceArray.min(by: { $0.value < $1.value })?.value ?? 0
    }

    var maxY: Double {
        priceArray.max(by: { $0.value < $1.value })?.value ?? 0
    }
    
    var minX: Date? {
        priceArray.min(by: { $0.date < $1.date } )?.date
    }
    
    var maxX: Date? {
        priceArray.max(by: { $0.date < $1.date } )?.date

    }
    
    var timespan: CoinGecko.TimeComponent {
        prices?.component ?? .init(component: .day, value: 30)!
    }
    
    var body: some View {
        if let prices {
            Chart {
                ForEach(priceArray, id: \.date) { price in
                     LineMark(
                         x: .value("Date", price.date),
                         y: .value("Price", price.value)
                     )
                     .foregroundStyle(.white)
                }
             }
            .chartYScale(domain: minY...maxY)
//            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
             .chartXAxis {
                 let count = timespan.value / 10

                 switch timespan.component {
                 case .day:
                     AxisMarks(position: .bottom, values: .stride(by: .day, count: count)) { _ in
                         AxisValueLabel(format: .dateTime.day(), centered: true)
                     }
                 case .month:
                     AxisMarks(position: .bottom, values: .stride(by: .month, count: count)) { _ in
                         AxisValueLabel(format: .dateTime.month(), centered: false)
                     }
                 case .year:
                     AxisMarks(position: .bottom, values: .stride(by: .year, count: count)) { _ in
                         AxisValueLabel(format: .dateTime.year(), centered: false)
                     }
                 case .weekOfYear, .weekOfMonth:
                     AxisMarks(position: .bottom, values: .stride(by: .weekOfMonth, count: count)) { _ in
                         AxisValueLabel(format: .dateTime.week(), centered: false)
                     }
                 default:
                     AxisMarks(position: .bottom, values: .automatic) { _ in
                         AxisValueLabel(centered: false)
                     }
                 }
             }

        }
    }
}

#Preview {
    PriceChart(evm: .ETH, contract: nil, full: false)
        .environment(PriceModel())
}
