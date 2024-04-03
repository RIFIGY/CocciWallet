//
//  NftContractView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI
import Web3Kit
import BigInt

struct NftContractView: View {
    @Environment(NetworkManager.self) private var network
    @Environment(NetworkCard.self) private var card
    
    @State var model: ERC721Model
    
    let address: String
    let name: String?
    let symbol: String?
    var description: String? = nil
        
    @State private var isEnumerable = false
    @State private var searchText = ""
    
    var tokenIdSearch: BigUInt? {
        guard !searchText.isEmpty, let _ = Int(searchText) else {return nil}
        return BigUInt(searchText)
    }
    
    
    
    var body: some View {
        Form {
            Section("Contract Address") {
                Text(address)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.secondary)
                    .onLongPressGesture {
                        Pasteboard.copy(address)
                    }
                if let description {
                    Text(description)
                        .foregroundStyle(.secondary)
                }
            }
            .textCase(nil)

//            if let baseURI = model.baseURI {
//                Headline("Base URI")
//                Text(baseURI.absoluteString)
//            }
            
            if let totalSupply = model.totalSupply {
                Section("Total Supply") {
                    HStack {
                        Text(totalSupply.description)
                        Spacer()
                        Button("Random"){
                            Task {
                                await model.search(tokenId: totalSupply.random(), with: network.getClient(card).node)
                            }
                        }
                        .font(.footnote)
                        .buttonStyle(.bordered)
                    }
                }
                
            }
            Section {
                HStack {
                    TextField("TokenID", text: $searchText)
                        .keyboardType(.numberPad)
                    Button("Search"){
                        Task {
                            if let tokenIdSearch {
                                await model.search(tokenId: tokenIdSearch, with: network.getClient(card).node)
                            }
                        }
                    }
                    .font(.footnote)
                    .buttonStyle(.bordered)
                }
            }
            if let (owner, token) = model.searchResult {
                Section {
                    Text(owner).lineLimit(1).minimumScaleFactor(0.6)
                    HStack {
                        if let name = token.metadata?.name {
                            Text(name)
                            if !name.contains(token.tokenId.description) {
                                Text("#\(token.tokenId.description)")
                            }
                        }
                    }
                } header: {
                    Text("Owner")
                } footer: {
                    NFTImageView(nft: token)
//                        .listRowBackground(Color.clear)
                }
            }
    }
        .navigationTitle(name ?? address)
        .conditional(model.isEnumerable) { view in
            view.searchable(text: $searchText)
            #if !os(macOS)
                .keyboardType(.numberPad)
            #endif
                .onSubmit {
                guard let tokenIdSearch else { print(searchText); return }
                Task {
                    await model.search(tokenId: tokenIdSearch, with: network.getClient(card).node)
                }
            }
        }
        .task {
            await model.checkEnumerable(client: network.getClient(card).node)
        }
    }
    
    func Headline(_ string: String) -> some View {
        Text(string)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top)
    }
}

@Observable
class ERC721Model {
    var totalSupply: BigUInt?
    var isEnumerable: Bool { totalSupply != nil }
    var tokenIds: [BigUInt] = []
    let contract: String
    
    var isSearching = false
    
    var searchResult: (String, NFTMetadata)?
    
    var baseURI: URL?
    
    init(contract: String) {
        self.contract = contract
    }

    func search(tokenId: BigUInt, with client: any ERC721Client) async {
        do {
            let owner = try await client.ownerOf(tokenId: tokenId, in: contract)
            let ownerString = owner
            let uri = try await client.getTokenURI(contract: contract, tokenId: tokenId)
            let nft = NFTMetadata(tokenId: tokenId, contract: contract, contractName: nil, symbol: nil, uri: uri)
            await nft.fetch()
            self.searchResult = (ownerString, nft)
            print("Search found metadata \(nft.metadata?.name ?? tokenId.description)")
        } catch {
            print("Search Error")
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func checkEnumerable(client: any ERC721Client) async {
        do {
            let totalSupply = try await client.totalSupply(contract: contract)
            self.totalSupply = totalSupply
        } catch {
            print(error)
        }
    }
}


import Web3Kit
extension NftContractView {
    init(_ contract: any ERC721Protocol) {
        self.address = contract.contract
        self.name = contract.name
        self.symbol = contract.symbol
        self._model = .init(wrappedValue: .init(contract: contract.contract))
//        self.description = contract.description
    }
}

#Preview {
    NavigationStack {
        NftContractView(ERC721.Munko)
            .environment(NetworkManager())
            .environment(NetworkCard.ETH)
    }
}

extension BigUInt {
    /// Generates a random BigUInt value between 0 and the self.
    /// - Returns: A random BigUInt value.
    func random() -> BigUInt {
        let upperBound = self
        var randomBytes = [UInt8](repeating: 0, count: (upperBound.bitWidth + 7) / 8)
        var randomValue: BigUInt
        
        repeat {
            // Fill randomBytes with random data
            for i in 0..<randomBytes.count {
                randomBytes[i] = UInt8.random(in: 0...UInt8.max)
            }
            // Create a BigUInt from randomBytes
            randomValue = BigUInt(Data(randomBytes))
            // Ensure randomValue is within the range [0, upperBound]
        } while randomValue >= upperBound
        
        return randomValue
    }
}
