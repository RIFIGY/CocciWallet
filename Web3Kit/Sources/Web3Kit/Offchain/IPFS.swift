//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/7/24.
//

import Foundation

public struct IPFS {
    
    public enum Gateway: String, CaseIterable {
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
            
    public static func gateway(uri url: URL, _ gateway: Gateway = .ipfs) -> URL {
        let urlString = url.absoluteString
        // Check if the URL starts with "ipfs://"
        if urlString.hasPrefix("ipfs://") {
            // Define the base URL for the IPFS gateway
            let gatewayPrefix = gateway.prefix
//            let gatewayPrefix =
            // Remove the "ipfs://" scheme
            var cidAndPath = urlString.replacingOccurrences(of: "ipfs://", with: "")
            
            // If the URL contained "ipfs/" after the scheme, remove it as it's redundant
            // This specifically targets the "ipfs://ipfs/Qme3..." scenario
            cidAndPath = cidAndPath.replacingOccurrences(of: "ipfs/", with: "")
            
            // Combine the gateway prefix with the CID and path
            let updatedString = gatewayPrefix + cidAndPath
            // Return the new URL
            return URL(string: updatedString)!
        } else {
            // Return the original URL if it doesn't start with "ipfs://"
            return url
        }
        
        
    }
    
}
