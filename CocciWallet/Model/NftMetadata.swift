//
//  NftMetadata.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import Foundation
import Web3Kit
import BigInt

@Observable
class NftMetadata {

    var metadata: OpenSeaMetadata?
    
    var imageUrl: URL? { URL(string: metadata?.image ?? "") }
    var image: PlatformImage?
    var additional: [String:Any]?

    var animation: Data?
    
    var name: String {
        metadata?.name ?? "#\(tokenId.description)"
    }
    
    var erc721: ERC721 { nft.token}
    var tokenId: BigUInt {nft.tokenId}
    var data: Data? { nft.metadata }
    
    let nft: ERC721.Token

    
    init(nft: ERC721.Token) {
        self.nft = nft
    }
    
    private let mediaCache = MediaCache.shared
    private let session = URLSession.shared
    
    
    func fetch() async {
        guard let data else {return}
        self.metadata = try? JSONDecoder().decode(OpenSeaMetadata.self, from: data)
        
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        self.additional = jsonObject as? [String: Any]
        
        await getImage()
    }
    
    func getImage() async {
        guard let url = imageUrl else {return}
        if let image = mediaCache.object(PlatformImage.self,for: url) {
            print("has cache")
//            self.image = image; return
        }
        do {
            let data = try await data(for: url)
            self.image = PlatformImage(data: data)
        }catch {
//            print("Image Error")
//            print(error)
        }
    }
        
    private func data(for url: URL) async throws -> Data {
        let gateway = IPFS.gateway(uri: url)
        let (data, _) = try await session.data(from: gateway)
        self.mediaCache.setData(data, for: url)
        return data
    }
}

extension NftMetadata: Identifiable, Equatable{
    static func == (lhs: NftMetadata, rhs: NftMetadata) -> Bool {
        lhs.id == rhs.id
    }
}
