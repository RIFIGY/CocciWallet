//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/26/24.
//

import Foundation

extension CoinGecko {
    static let Decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
