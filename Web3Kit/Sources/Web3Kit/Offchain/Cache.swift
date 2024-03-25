import Foundation

public protocol Cache {
    func setData(_ _: Data, forKey key: String)
    func getData(forKey key: String) -> Data?
    func removeData(forKey key: String)
}

extension Cache {
    
    public typealias AsyncFetchFunction<T> = () async throws -> T
    public typealias Expiration = (value: Int, component: Calendar.Component)


    public func store(data: Data, forKey key: String, expiresIn: Expiration? = nil) {
        let expirationDate: Date? = if let value = expiresIn?.value, let component = expiresIn?.component {
            Calendar.current.date(byAdding: component, value: value, to: Date())
        } else {
            nil // No expiration date
        }
        let cacheItem = CacheItem(lastUpdated: Date(), expirationDate: expirationDate, item: data)
        let cacheData = try? JSONEncoder().encode(cacheItem)
        if let cacheData {
            self.setData(cacheData, forKey: key)
        }
    }
    
    public func fetch(for key: String) -> Data? {
        guard let data = self.getData(forKey: key) else {return nil}
        do {
            let container = try JSONDecoder().decode(CacheItem.self, from: data)
            if let expirationDate = container.expirationDate, Date() > expirationDate {
                print("\(key) expired: \(Date().formatted()) > \(expirationDate.formatted())")
                self.removeData(forKey: key)
                return nil
            }
//            print("Using Cache for \(key)")
            return container.item
        } catch {
            return nil
        }
    }
    
    public func store<I: Codable>(_ item: I, forKey key: String, expiresIn: Expiration? = nil) {
        if let itemData = try? JSONEncoder().encode(item) {
            store(data: itemData, forKey: key, expiresIn: expiresIn)
        }
    }
    
    public func fetch<I:Codable>(_ type: I.Type = I.self,for key: String) -> I? {
        guard let data = fetch(for: key) else {return nil}
        return try? JSONDecoder().decode(I.self, from: data)
    }

}

private struct CacheItem: Codable {
    public var lastUpdated: Date
    public var expirationDate: Date?
    public var item: Data
}


//public extension Cache {
//    public func fetchAndCacheItem<T: Identifiable>(
//        forKey key: T.ID,
//        using fetchFunction: AsyncFetchFunction<T>,
//        expiration: Expiration? = nil
//    ) async throws -> T where T : Codable, T.ID == String {
//        if let cachedItem = fetch(T.self, forKey: key) {
//            return cachedItem
//        } else {
//            let item = try await fetchFunction()
//            try self.store(item, forKey: key, expiresIn: expiration)
//            return item
//        }
//    }
//
//}
