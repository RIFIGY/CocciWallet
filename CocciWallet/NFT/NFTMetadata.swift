////
////  NFTMetadata.swift
////  CocciWallet
////
////  Created by Michael Wilkowski on 3/18/24.
////
//
//import Foundation
//import Web3Kit
//import BigInt
//import OffChainKit
//import ChainKit
//
import WalletData

//typealias NFTMetadata = WalletData.NFT

//@Observable
//class NFTMetadata: Codable {
//    
//    let tokenId: BigUInt
//    let contract: String
//    let contractName: String?
//    let symbol: String?
//    let uri: URL?
//    private var json: Data?
//
//    var imageURL: URL?
//    private(set) var image: PlatformImage?
//    private(set) var metadata: OpenSeaMetadata?
//    
//    var additional: [String:Any] {
//        guard let json else  {return [:]}
//        let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String:Any]
//        return dict ?? [:]
//    }
//    
//    init(nft: Web3Kit.NFT, contract: any Contract, json: Data? = nil) {
//        self.tokenId = nft.tokenId
//        self.uri = nft.uri
//        self.contract = contract.contract.string
//        self.contractName = contract.name
//        self.symbol = contract.symbol
//        self.json = json
//        try? decodeMetadata()
//    }
//    
//    init(tokenId: BigUInt, contract: String, contractName: String?, symbol: String?, uri: URL?, json: Data? = nil) {
//        self.tokenId = tokenId
//        self.contract = contract
//        self.contractName = contractName
//        self.symbol = symbol
//        self.uri = uri
//        self.json = json
//        try? decodeMetadata()
//    }
//    
//    convenience init(contract: any Contract, tokenId: BigUInt, uri: URL?, json: Data? = nil) {
//        self.init(tokenId: tokenId, contract: contract.contract.string, contractName: contract.name, symbol: contract.symbol, uri: uri, json: json)
//    }
//    
//    func fetch() async {
//        do {
//            try await fetchJSON()
//            try decodeMetadata()
////            try await fetchImage()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    
//    private func fetchJSON() async throws {
//        guard let uri, json == nil else {return}
//        let gateway = IPFS.Gateway(uri)
//        let (data, _) = try await URLSession.shared.data(from: gateway)
//        self.json = data
//    }
//    
//    private func decodeMetadata() throws {
//        guard let json else {return}
//        let metadata = try JSONDecoder().decode(OpenSeaMetadata.self, from: json)
//        self.metadata = metadata
//        if let image = metadata.image, let url = URL(string: image) {
//            self.imageURL = url
//        }
//    }
//    
//    
//    private func fetchImage() async throws {
//        guard let url = imageURL else {return}
//        
//        let gateway = IPFS.Gateway(url)
//        let (data, _) = try await URLSession.shared.data(from: gateway)
//        self.image = PlatformImage(data: data)
//    }
//    
//}
//
//extension NFTMetadata: Identifiable, Equatable, Hashable{
//    static func == (lhs: NFTMetadata, rhs: NFTMetadata) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//extension NFTMetadata {
//    enum CodingKeys: String, CodingKey {
//        case tokenId, contract, contractName, symbol, uri
//        case _json = "json"
//        case _imageURL = "imageURL"
//    }
//}
