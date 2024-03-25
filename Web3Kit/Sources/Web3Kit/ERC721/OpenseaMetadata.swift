//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation


public protocol ERC721MetadataProtocol: Codable {
    var name: String? {get}
    var image: String? {get}
}

public struct OpenSeaMetadata: Codable, ERC721MetadataProtocol {
    public let name: String?
    public let image: String?
    public let description: String?
    public let external_url: String?
    public let image_data: Data?
    public let background_color: String?
    public let animation_url: String?
    public let youtube_url: String?
    public let attributes: [Attribute]?
}

public extension OpenSeaMetadata {
    struct Attribute: Codable, Identifiable {
        
        public var id: String { traitType }
        public let traitType: String
        public let value: AttributeValue
        public let displayType: String?
        
        public enum CodingKeys: String, CodingKey {
            case traitType = "trait_type"
            case value
            case displayType = "display_type"
        }
        
        public var asString: String {
            switch value {
            case .string(let string):
                string
            case .int(let int):
                int.description
            case .double(let double):
                double.description
            }
        }
        
        public var stringValue: String? {
            switch value {
            case .string(let stringValue):
                return stringValue
            default: return nil
            }
        }
        
        public var intValue: Int? {
            if case let .int(data) = value {
                return data
            } else {
                return nil
            }
        }
        
        public var doubleValue: Double? {
            switch value {
            case .double(let doubleValue):
                return doubleValue
            default: return nil
            }
        }
    }
    
    enum AttributeValue: Codable {
        case string(String)
        case int(Int)
        case double(Double)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
            } else if let doubleValue = try? container.decode(Double.self) {
                self = .double(doubleValue)
            } else {
                self = .string(try container.decode(String.self))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let stringValue):
                try container.encode(stringValue)
            case .int(let intValue):
                try container.encode(intValue)
            case .double(let doubleValue):
                try container.encode(doubleValue)
            }
        }
    }
}
