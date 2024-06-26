//
//  TimelineProvider.swift
//  WidgetsExtension
//
//  Created by Michael Wilkowski on 3/30/24.
//

import WidgetKit
import OffChainKit
import AppIntents

struct NftEntry: TimelineEntry {
    let date: Date
    let intent: NFTIntent
    var uiImage: PlatformImage?
    var images: [PlatformImage?] = []
    var error: String?
}

extension NFTIntent: WidgetConfigurationIntent {}

struct NftProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> NftEntry {
        NftEntry(date: .now, intent: NFTIntent())
    }
    
    func snapshot(for intent: NFTIntent, in context: Context) async -> NftEntry {
        NftEntry(date: .now, intent: intent)
    }
        
    func timeline(for intent: NFTIntent, in context: Context) async -> Timeline<NftEntry> {
        
        var entry = NftEntry(date: .now, intent: intent)
        
        if intent.randomNFT {
//            entry.intent.nft = randomNFT(for: intent.wallet.id, network: intent.network?.id, contract: intent.contract?.contract)
        }
        
        do {
            let image = try await fetchImage(nft: entry.intent.nft)
            entry.uiImage = image
            entry.images = await getImages(nfts: intent.nfts)
            
            if let nextInterval = nextInterval(intent), intent.randomNFT {
                return Timeline(entries: [entry], policy: .after(nextInterval) )
            } else {
                return Timeline(entries: [entry], policy: .never )
            }
            
        } catch {
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 10, to: .now)!
            entry.error = error.localizedDescription
            return Timeline(entries: [entry], policy: .after(nextUpdate) )
            
        }
    }
}

extension NftProvider {
    
    private func fetchImage(nft: NFTEntity?) async throws -> PlatformImage? {
        guard let imageUrl = nft?.imageURL else {return nil}
        let gateway = IPFS.Gateway(imageUrl)
        let (data, _) = try await URLSession.shared.data(from: gateway)
        return PlatformImage(data: data)

    }
    
    private func randomNFT(for wallet: String, network: String, contract: String? = nil) async -> NFTEntity? {
        nil
//        let nfts = await WalletContainer.shared.fetchAllNFTs(wallet: wallet, networkID: network, contract: contract)
//        if let random = nfts.randomElement() {
//            #warning("fix this")
//            return .init(random)
//        } else {return nil}
        
    }
    
    private func nextInterval(_ intent: NFTIntent) -> Date? {
        guard intent.randomNFT else {return nil}
        let interval = intent.interval.component
        let frequency = intent.frequency
        
        let nextUpdateDate = Calendar.current.date(byAdding: interval, value: frequency, to: .now)!

        return nextUpdateDate
    }
    
    private func getImages(nfts: [NFTEntity]?) async -> [PlatformImage?] {
        if let nfts, nfts.count == 2 {
            let nft1 = nfts[0]
            let image1 = try? await fetchImage(nft: nft1)
            
            let nft2 = nfts[1]
            let image2 = try? await fetchImage(nft: nft2)
            
            return [image1, image2]
        } else {
            return []
        }
    }
}



