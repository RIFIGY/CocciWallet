//
//  NFTGridView.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import ChainKit
import Web3Kit


struct NFTGallery: View {
    
    let nfts: [NFT]
    var onTap: ((NFT) -> Void)? = nil

    @State private var searchText = ""
    @State private var layout = BrowserLayout.grid
    @State private var group = true
    
    var filteredNFTs: [NFT] {
        nfts
    }
    
    var tableImageSize: Double {
        #if os(macOS)
        return 30
        #else
        return 60
        #endif
    }
    
    var body: some View {
        ZStack {
            if layout == .grid {
                grid
            } else {
                NFTTable(nfts: nfts, group: group)
            }
        }
        .background()
        #if os(iOS)
        .toolbarRole(.browser)
        #endif
        .toolbar {
            ToolbarItemGroup {
                toolbarItems
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Donuts")
    }
    
    var grid: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                NFTGridView(nfts: filteredNFTs, width: geometryProxy.size.width, group: group, onTap: onTap)
            }
        }
    }
    

    
    @ViewBuilder
    var toolbarItems: some View {
        Menu {
            Picker("Layout", selection: $layout) {
                ForEach(BrowserLayout.allCases) { option in
                    Label(option.title, systemImage: option.imageName)
                        .tag(option)
                }
            }
            .pickerStyle(.inline)
            Toggle("Group", isOn: $group)

//            Picker("Sort", selection: $sort) {
//                Label("Name", systemImage: "textformat")
//                    .tag(DonutSortOrder.name)
//                Label("Popularity", systemImage: "trophy")
//                    .tag(DonutSortOrder.popularity(popularityTimeframe))
//                Label("Flavor", systemImage: "fork.knife")
//                    .tag(DonutSortOrder.flavor(sortFlavor))
//            }
//            .pickerStyle(.inline)
//            
//            if case .popularity = sort {
//                Picker("Timeframe", selection: $popularityTimeframe) {
//                    Text("Today")
//                        .tag(Timeframe.today)
//                    Text("Week")
//                        .tag(Timeframe.week)
//                    Text("Month")
//                        .tag(Timeframe.month)
//                    Text("Year")
//                        .tag(Timeframe.year)
//                }
//                .pickerStyle(.inline)
//            } else if case .flavor = sort {
//                Picker("Flavor", selection: $sortFlavor) {
//                    ForEach(Flavor.allCases) { flavor in
//                        Text(flavor.name)
//                            .tag(flavor)
//                    }
//                }
//                .pickerStyle(.inline)
//            }
        } label: {
            Label("Layout Options", systemImage: layout.imageName)
                .labelStyle(.iconOnly)
        }
    }
}



enum BrowserLayout: String, Identifiable, CaseIterable {
    case grid
    case list

    var id: String {
        rawValue
    }

    var title: LocalizedStringKey {
        switch self {
        case .grid: return "Icons"
        case .list: return "List"
        }
    }

    var imageName: String {
        switch self {
        case .grid: return "square.grid.2x2"
        case .list: return "list.bullet"
        }
    }
}

//
//#Preview {
//    NFTGridView()
//}
