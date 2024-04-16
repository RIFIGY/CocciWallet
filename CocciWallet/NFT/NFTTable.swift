//
//  NFTTable.swift
//  CocciWallet
//
//  Created by Michael on 4/15/24.
//

import SwiftUI

struct NFTTable: View {
    let nfts: [NFT]
    let group: Bool
    var onTap: ((NFT) -> Void )? = nil
    
    @State private var sortOrder: [KeyPathComparator<NFT>] = [
        .init(\.tokenId, order: .forward),
    ]
        
    
    var grouped: [String : [NFT] ] {
        Dictionary(grouping: nfts, by: {$0.contract})
    }
    
    var contracts: [String] {
        grouped.keys.map{$0}
    }
    
    var body: some View {
        Table(
            of: NFT.self,
            sortOrder: $sortOrder
        ) {

            TableColumn("") { nft in
                if let onTap {
                    Cell(nft: nft)
                        .onTapGesture {
                            onTap(nft)
                        }
                } else {
                    NavigationLink {
                        NFTDetail(nft: nft)
                    } label: {
                        Cell(nft: nft)
                    }
                }
                
            }
            TableColumn("Token", value: \.tokenId)
            TableColumn("Contract", value: \.contract)
//            if !group {
//                TableColumn("Contract", value: \.token.contract)
//            }

        } rows: {
            if group {
                ForEach(contracts, id: \.self) { contract in
                    Section {
                        if let nfts = grouped[contract] {
                            ForEach(nfts.sorted(using: sortOrder)) { nft in
                                TableRow(nft)
                            }
                        }
                    } header: {
                        Text(contract)
                            .font(.title3)
                    }
                }
            } else {
                ForEach(nfts.sorted(using: sortOrder)) { nft in
                    TableRow(nft)
                }
            }


        }
    }
    
    struct Cell: View {
        
        var tableImageSize: Double {
            #if os(macOS)
            return 60
            #else
            return 100
            #endif
        }
        
        let nft: NFT

        var body: some View {
            HStack {
                NFTImageView(nft: nft.token, contentMode: .fit)
                    .frame(width: tableImageSize, height: tableImageSize)
                Text(nft.token.name ?? "")
            }
        }
    }
    
}

#Preview {
    NFTTable(nfts: [], group: true)
}
