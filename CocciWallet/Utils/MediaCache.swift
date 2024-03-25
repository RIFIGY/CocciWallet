//
//  MediaCache.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif


class MediaCache {
    static let shared = MediaCache()

    private let cache = NSCache<NSURL, Data>()

    private init() {}

    func setData(_ data: Foundation.Data, for url: URL) {
        cache.setObject(Data(data), forKey: url as NSURL)
    }

    func data(for url: URL) -> Foundation.Data? {
        cache.object(forKey: url as NSURL)?.value
    }
    
    func object<D>(_ type: D.Type = D.self, for url: URL) -> D? {
        guard let data = data(for: url) else { return nil }

        if type == PlatformImage.self {
            return PlatformImage(data: data) as? D
        } else {
            if let decodableType = type as? Decodable.Type {
                let object = try? JSONDecoder().decode(decodableType.self, from: data)
                return object as? D
            } else {
                return nil
            }
        }
    }
    
    class Data: NSObject {
        let value: Foundation.Data

        init(_ data: Foundation.Data) {
            self.value = data
        }
    }
    
    enum Format: String, CaseIterable {
        case video, audio, image
    }
}
