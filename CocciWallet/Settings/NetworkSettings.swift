//
//  NetworkCardSettings.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI
import BigInt

struct NetworkSettings: View {
    @AppStorage(AppStorageKeys.favoriteNFT, store: UserDefaults.group) var favoriteNFT: String = ""
    @Bindable var card: Network
    
    var color: Color { card.color }
    var chain: Int { card.chain }
    var remove: ()->Void = {}
    

    
    
    var body: some View {
        Form {
            Section {
                IconCell(systemImage: "circle", color: color) {
                    Toggle("Show Balance", isOn: $card.settings.showBalance)
                        .toggleStyle(SwitchToggleStyle(tint: color))
                }
            }
            
//            SelectNFTCell(nfts: card.nfts, nft: $card.settings.coverNFT)
            
            Section {
                NavigationLink {
                    List {
                        ForEach(card.settings.blockList, id: \.self) { contract in
                            Text(contract)
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                                
                        }
                        .onDelete{ indexSet in
                            card.settings.blockList.remove(atOffsets: indexSet)
                        }
                    }
                    #if os(iOS)
                    .toolbar {
                        ToolbarItem{
                            EditButton()
                        }
                    }
                    #endif
                } label: {
                    IconCell(systemImage: "triangle", color: .orange) {
                        Text("Block List")
                    }
                }
            }
            
            
            if card.isCustom {
                Section {
                    NavigationLink {
                        AdvancedNetworkSettings(card: card)
                    } label: {
                        Text("Advanced")
                    }
                }
            }
            
            Section {
                Button("Remove", role: .destructive) {
                    remove()
                }
                .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(card.name)

    }
}

struct SelectNFTCell: View {
    let nfts: [NFT]
    @Binding var nft: NFTEntity?
    
    @State private var chooseNftTapped = false
    @State private var randomNFT = true
    
    var body: some View {
        Section {
            IconCell(systemImage: "square", color: .indigo) {
                HStack {
                    Text("Cover NFT")
                    Spacer()
                    Button(randomNFT ? "Random" : "Choose NFT") {
                        self.randomNFT.toggle()
                    }
                }
            }
            if !randomNFT {
                HStack {
                    Spacer()
                    if let nft {
                        Text(nft.name ?? nft.tokenId)
                    } else {
                        Button("Choose NFT") {
                            self.chooseNftTapped = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $chooseNftTapped) {
            NavigationStack {
                NFTGallery(nfts: nfts) { nft in
                    chooseNftTapped = false
//                    Task{@MainActor in
//                        self.card.settings.coverNFT = nft.token
//                    }
                }
            }
        }
    }
}

struct AdvancedNetworkSettings: View {
    @Environment(\.dismiss) private var dismiss
    
    var color: Color { card.color }
    var chain: Int { card.chain }
    
    @Bindable var card: Network
    
    @State private var testedRpc: Bool = false
    
    

    var body: some View {
        Form {
            if card.isCustom {
//                CustomNetworkView(name: $card.name, chainId: $card.chain, symbol: $card.nativeCoin.symbol, rpc: $card.rpc)
            } else {
//                RpcTextField(rpc: $card.entity.rpc, chain: chain, color: color, label: "RPC", validURL: $testedRpc)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Save"){
                    dismiss()
                }
                .disabled(!testedRpc)
            }
        }
        .navigationTitle("Advanced")
    }
    

}
//
//#Preview {
//    NavigationStack {
//        NetworkCardSettings(card: .ETH)
//    }
//}
//                IconCell(systemImage: "photo.artframe", color: .purple) {
//                    Text("Favorite NFT")
//                    Spacer()
//                    Menu(nftLabel) {
//                        Button("Random") { card.settings.coverNFT = nil; withAnimation{ chooseNftTapped = false } }
//                        Button("Choose") { withAnimation { chooseNftTapped = true } }
//                    }
//                }
//                if let coverNFT = card.settings.coverNFT {
//                    NavigationLink {
//                        NftListView(tokens: card.nfts.tokens) { metadata in
//                            self.favoriteNFT = metadata.tokenId.description
//                            card.settings.coverNFT = .init(nft: metadata)
//                        }
//                    } label: {
//                        Text(nftName ?? coverNFT.tokenId.description)
//                    }
//                } else if chooseNftTapped {
//                    NavigationLink {
//                        NftListView(tokens: card.nfts.tokens) { metadata in
//                            self.favoriteNFT = metadata.tokenId.description
//                            card.settings.coverNFT = .init(nft: metadata)
//                        }
//                    } label: {
//                        HStack {
//                            Spacer()
//                            Text("Choose").foregroundStyle(.secondary)
//                        }
//                    }
//                }
