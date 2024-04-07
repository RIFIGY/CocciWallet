//
//  UserDefaults+Codable.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/17/24.
//

import Foundation

extension UserDefaults {
    
    func setCodable<E:Encodable>(_ object: E, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            self.setData(data, forKey: key)
        }
    }
    
    func getCodable<D:Decodable>(_ type: D.Type = D.self, forKey key: String) -> D? {
        guard let data = getData(forKey: key) else {return nil}
        return try? JSONDecoder().decode(type, from: data)
    }
    
}

#if canImport(OffChainKit)
import OffChainKit
extension UserDefaults: Cache {}
#endif

extension UserDefaults {
    public func setData(_ data: Data, forKey key: String) {
        self.set(data, forKey: key)
    }
    
    public func getData(forKey key: String) -> Data? {
        self.data(forKey: key)
    }
    
    public func removeData(forKey key: String) {
        self.removeObject(forKey: key)
    }
}
