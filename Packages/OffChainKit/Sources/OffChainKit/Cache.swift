import Foundation

public protocol Cache {
    func setData(_ _: Data, forKey key: String)
    func getData(forKey key: String) -> Data?
    func removeData(forKey key: String)
}

private struct CacheItem: Codable {
    public var lastUpdated: Date = .now
    public var expirationDate: Date?
    public var item: Data
}

extension Cache {
    
    public typealias AsyncFetchFunction<T> = () async throws -> T
    public typealias Expiration = (value: Int, component: Calendar.Component)

    public func store(
        data: Data, 
        forKey key: String,
        expiresIn: Expiration? = nil
    ) {

        if let expiresIn {
            let expirationDate = date(expiresIn)
            let cacheItem = CacheItem(
                expirationDate: expirationDate,
                item: data
            )
            let cacheData = try? JSONEncoder().encode(cacheItem)
            if let cacheData {
                self.setData(cacheData, forKey: key)
            }
        } else {
            self.setData(data, forKey: key)
        }
        

    }
    
    public func fetch(for key: String) -> Data? {
        guard let data = self.getData(forKey: key) else { return nil }
        
        guard let container = try? JSONDecoder().decode(CacheItem.self, from: data) else {
            return data
        }
        
        if let expirationDate = container.expirationDate, Date() > expirationDate {
            self.removeData(forKey: key)
            return nil
        }
        return container.item
    }
    
    public func store<I: Codable>(
        _ item: I,
        forKey key: String,
        expiresIn: Expiration? = nil
    ) {
        if let itemData = try? JSONEncoder().encode(item) {
            store(data: itemData, forKey: key, expiresIn: expiresIn)
        }
    }
    
    public func fetch<I:Decodable>(_ type: I.Type = I.self, for key: String) -> I? {
        guard let data = fetch(for: key) else {return nil}
        return try? JSONDecoder().decode(I.self, from: data)
    }
    
    private func date(_ expiresIn: Expiration?) -> Date? {
        guard let value = expiresIn?.value, 
                let component = expiresIn?.component
        else { return nil }
        
        return Calendar.current.date(byAdding: component, value: value, to: .now)
    }
}
