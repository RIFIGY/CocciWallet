//
//  NftContractView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI

struct NftContractView: View {
    
    let address: String
    let name: String?
    let symbol: String?
    var description: String? = nil
        
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                if let name {
                    Text(name)
                        .font(.largeTitle.weight(.bold))
                } else {
                    Text(address)
                        .minimumScaleFactor(0.9)
                }
                if let description {
                    Text(description)
                        .foregroundStyle(.secondary)
                }
                Section {
                    Text(address)
                        .font(.caption2)
                         .foregroundStyle(.secondary)
                } header: {
                    Headline("Contract Address")
                }
            }
        }
    }
    
    func Headline(_ string: String) -> some View {
        Text(string)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top)
    }
}


import Web3Kit
extension NftContractView {
    init(_ contract: any ERC721Protocol) {
        self.address = contract.contract
        self.name = contract.name
        self.symbol = contract.symbol
//        self.description = contract.description
    }
}

#Preview {
    NftContractView(ERC721.Munko)
}
