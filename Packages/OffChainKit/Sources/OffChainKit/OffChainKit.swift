// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation

enum ResourceError:Error {
    case none, decode
}

func JSON<D:Decodable>(_ type: D.Type = D.self, resource: String, with decoder: JSONDecoder = JSONDecoder()) throws -> D {
    guard let bundlePath = Bundle.module.url(forResource: resource, withExtension: "json") else {
        throw ResourceError.none
    }
    let data = try Data(contentsOf: bundlePath)
    let object = try decoder.decode(type, from: data)
    
    return object
}



