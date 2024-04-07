//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/7/24.
//

import Foundation

public struct IPFS {
    
    public enum GatewayProvider: String, CaseIterable {
        case ipfs, cloudflare
        
        public var prefix: String {
            switch self {
            case .ipfs:
                "https://ipfs.io/ipfs/"
            case .cloudflare:
                "https://cloudflare-ipfs.com/ipfs/"
            }
        }
    }
            
    public static func Gateway(_ url: URL, _ provider: GatewayProvider = .ipfs) -> URL {
        let urlString = url.absoluteString
        
        if urlString.hasPrefix("ipfs://") {
            
            let gatewayPrefix = provider.prefix
            
            var cidAndPath = urlString.replacingOccurrences(of: "ipfs://", with: "")
            
            cidAndPath = cidAndPath.replacingOccurrences(of: "ipfs/", with: "")
            
            let updatedString = gatewayPrefix + cidAndPath
            
            return URL(string: updatedString)!
        } else {
            return url
        }
    }
    
}


public extension URL {
    
    var cloudflareIpfs: Self {
        IPFS.Gateway(self, .cloudflare)
    }
    
    var ipfs: Self {
        IPFS.Gateway(self, .ipfs)
    }
}
