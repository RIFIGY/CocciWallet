//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/11/24.
//

import Foundation

public extension URL {
    
    var cloudflareIpfs: Self {
        IPFS.gateway(uri: self, .cloudflare)
    }
    
    var ipfs: Self {
        IPFS.gateway(uri: self, .ipfs)
    }
}
