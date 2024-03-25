//
//  NftMediaView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI
import AVKit


struct MediaView: View {
    let url: URL
    let trait: String
    
    var mediaType: MediaType {
        url.media
    }
    
    var body: some View {
        switch mediaType {
        case .mp4:
            VideoPlayerView(url: url)
        case .jpg, .png, .svg, .gif:
            NFTImageView(url: url)
        case .unknown, .usdz:
            if ["animation", "video"].contains(where: { trait.lowercased().contains($0.lowercased()) } ) {
                VideoPlayerView(url: url)
            } else {
                WebView(url)
            }
            
        }
        
    }
}

struct VideoPlayerView: View {
    let url: URL
    @State private var player = AVPlayer()

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.replaceCurrentItem(with: AVPlayerItem(url: url))
                player.play() // Start playing the video as soon as the view appears
            }
            .onDisappear {
                player.pause() // Optional: Pause the video when the view disappears
            }
            .aspectRatio(contentMode: .fit)
    }
}



public extension URL {
    
    var isIpfs: Bool {
        self.scheme?.lowercased() == "ipfs"
    }
    
    
    var media: MediaType {
        switch self.pathExtension.lowercased() {
        case "mp4":
            return .mp4
        case "jpg", "jpeg":
            return .jpg
        case "png":
            return .png
        case "svg":
            return .svg
        case "gif":
            return .gif
        case "usdz":
            return .usdz
        default:
            return .unknown
        }
    }
}

public enum MediaType: String {
    case unknown, mp4, jpg, png, svg, gif, usdz
    
    public var systemName: String {
        switch self {
        case .unknown:
            "circle"
        case .mp4:
            "video"
        case .jpg, .png:
            "photo"
        case .svg:
            "doc.text.image"
        case .gif:
            "wand.and.stars"
        case .usdz:
            "cube.transparent"
        }
    }
    
}

//#Preview {
//    NftMediaView()
//}
