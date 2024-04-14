//
//  NFTDetail.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import SwiftUI
import Web3Kit


struct NFTDetail: View {
    let nft: NFTEntity
    
    var metadata: OpenSeaMetadata? {
        nft.opensea
    }
    
    var nftImageName: some View {
        VStack {
            NFTImageView(nft: nft)
            Text(metadata?.name ?? "")
                .font(.largeTitle.weight(.bold))
                .padding(.top)
            Text(metadata?.description ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
        }
    }
    
    var body: some View {
        #if os(macOS)
        HSplitView {
            nftImageName
            .layoutPriority(1)

            Form {
                LabeledContent("TokenID", value: nft.tokenId.description)
                attributes
            }
            .formStyle(.grouped)
            .padding()
            .frame(minWidth: 300, idealWidth: 350, maxHeight: .infinity, alignment: .top)
        }
        #else
        WidthThresholdReader { proxy in
            if proxy.isCompact {
                Form {
                    nftImageName
                    attributes
                }
            } else {
                HStack(spacing: 0) {
                    nftImageName
                        .padding(.horizontal)
                    Spacer()
                    Divider().ignoresSafeArea()
                    Form {
                        attributes
                    }
                    .formStyle(.grouped)
                    .frame(width: 350)
                }
            }
        }
        #endif
    }
    
    @ViewBuilder
    var attributes: some View {

        if let attributes = metadata?.attributes {
            Section {
                if !attributes.strings.isEmpty {
                    Section {
                        ForEach(attributes.strings) { att in
                            LabeledContent(att.traitType, value: att.stringValue ?? "")
                        }
                    } header: {
                        Text("Properties")
                            .font(.caption)
                            .padding(.top, 8)
                        
                    }
                }
                if !attributes.ints.isEmpty {
                    Section {
                        ForEach(attributes.ints) { att in
                            LabeledContent(att.traitType, value: att.intValue?.description ?? "")
                        }
                    } header: {
                        Text("Values")
                            .font(.caption)
                            .padding(.top)
                    }
                }
                
                if !attributes.doubles.isEmpty {
                    Section {
                        ForEach(attributes.doubles) { att in
                            LabeledContent(att.traitType, value: att.doubleValue?.formatted(.number) ?? "")
                        }
                    } header: {
                        Text("Values")
                            .font(.caption)
                            .padding(.top)
                    }
                }
            } header: {
                Text("Attributes")
            }
        }
    }
}
//
//#Preview {
//    NFTDetail()
//}
