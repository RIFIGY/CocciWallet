////
////  File.swift
////  
////
////  Created by Michael Wilkowski on 3/7/24.
////
//
//import Foundation
//
//public struct Infura {
//    fileprivate let API_KEY: String
//    fileprivate let base = ".infura.io/"
//    
//    private let session: URLSession
//    private let cache: (any Cache)?
//    
//    public init(
//        api_key: String,
//        session: URLSession,
//        cache: (any Cache)? = nil
//    ){
//        self.API_KEY = api_key
//        self.session = session
//        self.cache = cache
//    }
//    
//        
//    public func URL(chain: Chain = .mainnet, websocket: Bool = false) -> Foundation.URL {
//        let version = websocket ? "ws/v3/" : "v3/"
//        let chain = chain.name
//        let clientUrl = Foundation.URL(string:
//            "https://" + chain + base + version + API_KEY
//        )
//        return clientUrl!
//    }
//    
////    public func ping(chain: Chain) async throws -> Bool {
////        return true
////    }
//}
//
