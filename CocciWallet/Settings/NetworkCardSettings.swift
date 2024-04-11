//
//  NetworkCardSettings.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/28/24.
//

import SwiftUI
import BigInt

struct NetworkCardSettings: View {
    @Bindable var card: EthereumNetworkCard
    var remove: ()->Void = {}
    
    var body: some View {
        Web3NetworkCardSettings(card: card, remove: remove)
    }

}

struct Web3NetworkCardSettings: View {
    @AppStorage(AppStorageKeys.favoriteNFT, store: UserDefaults.group) var favoriteNFT: String = ""
    @Bindable var card: EthereumNetworkCard
    
    var color: Color { card.color }
    var chain: Int { card.chain }
    var remove: ()->Void = {}
    
    @State private var chooseNftTapped = false
    
    
    var body: some View {
        Form {
            Section {
                IconCell(systemImage: "circle", color: color) {
                    Toggle("Show Balance", isOn: $card.settings.showBalance)
                        .toggleStyle(SwitchToggleStyle(tint: color))
                }
                
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

            }
            
            Section {
                NavigationLink {
                    AdvancedNetworkSettings(card: card)
                } label: {
                    Text("Advanced")
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
    
    var nftName: String? {
        nil
//        if let coverNFT = card.settings.coverNFT {
//            if let contractName = coverNFT.contractName, coverNFT.metadata?.name == coverNFT.tokenId.description {
//                return contractName + ": " + coverNFT.tokenId.description
//            } else if let name = coverNFT.metadata?.name, name != coverNFT.tokenId.description {
//                return name
//            } else {
//                return coverNFT.tokenId.description
//            }
//        } else {return nil}
    }
    
    var nftLabel: String {
        if let nftName {
            nftName
        } else {
            "Random"
        }
    }
}
struct AdvancedNetworkSettings: View {
    @Environment(\.dismiss) private var dismiss
    
    var color: Color { card.color }
    var chain: Int { card.chain }
    
    @Bindable var card: EthereumNetworkCard
    
    @State private var testedRpc: Bool = false
    
    

    var body: some View {
        Form {
            if card.isCustom {
//                CustomNetworkView(name: $card.name, chainId: $card.chain, symbol: $card.nativeCoin.symbol, rpc: $card.rpc)
            } else {
                RpcTextField(rpc: $card.rpc, chain: chain, color: color, label: "RPC", validURL: $testedRpc)
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
