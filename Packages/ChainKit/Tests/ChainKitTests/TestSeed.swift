//
//  File.swift
//  
//
//  Created by Michael on 4/5/24.
//

import Foundation
@testable import ChainKit

struct TestSeed {
    static let mnemonic = "game lawn cigar main second toe question eagle pencil slush love problem"
    static let solanaMnemonic = "awful shield hurry affair catch exact sugar prevent salute replace absorb swear"

    struct Bitcoin {
        static let derivationPath = "m/44'/0'/0'/0/INDEX"
        
        static let private_key_0 = "L3NgEWKhHkhuhB9EPQA5R4F1ZceytZHUzvw6cVKrNnBCEBrDjJmS"
        static let public_key_0 = "0214326386d4f66e3d8ba52a91a61808b3c4223cf26705ca84452f36cd9f05a8ef"
        static let address_0 = "1Pq1vkAj55Xn5bPoCGotG1XXNLKKSdRtGM"
        
        static let private_key_1 = "KxBiEsBLRTZzM8aRYTa3BrxHxfoNAvuJ3nRWLaffWhtakDPSah6v"
        static let public_key_1 = "027b379364f67e9c9ad8de7fd758f2b356462ba9c577c4f377446c3d806280bcf3"
        static let address_1 = "18JFtS6KTP139qWMQMYoHRs8h7x9iw21Lx"
    }
    
    struct Ethereum {
        static let derivationPath = "m/44'/60'/0'/0/INDEX"
        static let private_key_0 = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
        static let address_0 = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
        
        static let private_key_1 = "0x92b76263170d705355e0d5a7b961f05e56e12c97f9cd3894c450486b13b85f9e"
        static let address_1 = "0x9cd729B8380B55bf7D63d30f42e7D231cc56Ba11"
    }
    
    struct Litecoin {
        static let derivationPath = "m/44'/2'/0'/0/INDEX"
        
        static let private_key_0 = "T4TGMZdJCqoHUu1QYfKAYJtTqA9jttTyxPsxsE5JtVhJ1giMGkch"
        static let public_key_0 = "03b8e2c335a7eabda621388c8261b1f86c3775e1dbbd630cedacc3ac79d966a0ae"
        static let address_0 = "La425FmwtVyyKXRM469k9AtjTG7PgfxRjJ"
        
        static let private_key_1 = "T51kFmBC7r7z6DekxkQ9CGERBsxE677Fqvs9jPXhQSLFQzAWoyxm"
        static let public_key_1 = "030d19a79037776017c16f40fd04603eabe5cb90abb087d5c4fd762c9682d66779"
        static let address_1 = "LYTyrCjGHpGu39iJ9epcnoHcHxJCzFZJPw"
    }
    
    struct Dogecoin {
        static let derivationPath = "m/44'/3'/0'/0/INDEX"
        
        static let private_key_0 = "QWv6wuUVBFkxS4WQwtoULrqwwtc29e5LyHjUGjy613DoeymP689F"
        static let public_key_0 = "03ea8987d2e3757222c02c10b789771d7a4286182d90c7380b2409de613807a6ee"
        static let address_0 = "DQDYNQ2d6Sj38FBYir3RFVmdhNMb5tQ6u9"
        
        static let private_key_1 = "QS3ZDB1kcofgmNVjbNFbsZ7bSDweTZbns6wcU8HZqpfCsdU2uSE6"
        static let public_key_1 = "031641a9e9434993ac8bc431e7235757fbf56066dd9fde90c1a2d8bd40004852eb"
        static let address_1 = "DR78z3SAHTYoqF6zHuN9uTKg1LD3kEGuw9"
    }
    
    struct Solana {
        static let derivationPath = "m/44'/501'/0'/0/INDEX"
        
        static let private_key_0 = "36LMFD8uMjFnXGwHPZuYBMZq82qhubL887JbhYYvLHiyqGzYjMGbaXTfcC3t6mgnn15SCQ8mZmUhWQ6FLYMs9yTJ"
        static let public_key_0 = ""
        static let address_0 = "81pv4D7KTXsvm99BvtQ6tHJmieuKJxzYMi9DLprFrygm"
        
//        static let eth_private_key = "0x8f337acb395707baec68b4bbbf9458be0311d332aa34bcec100380fcb023c26e"
//        static let eth_address_0 = "0xbdF8e02e7c9Ba4b2Ba91f168Ca0bf18E1e8075A6"
        
    }
}

extension TestSeed {
    static var addresses: [(privateKey: String, address: String)] {
        [
            (ethereum.private_key_0, ethereum.address_0),
            (ethereum.private_key_1, ethereum.address_1),
            (bitcoin.private_key_0, bitcoin.address_0),
            (bitcoin.private_key_1, bitcoin.address_1),
            (litecoin.private_key_0, litecoin.address_0),
            (litecoin.private_key_1, litecoin.address_1),
            (doge.private_key_0, doge.address_0),
            (doge.private_key_1, doge.address_1),
            (solana.private_key_0, solana.address_0),
            
        ]
    }
}

typealias Keys = (privateKey: String, publicKey: String, address: String)
typealias ethereum = TestSeed.Ethereum
typealias bitcoin = TestSeed.Bitcoin
typealias litecoin = TestSeed.Litecoin
typealias doge = TestSeed.Dogecoin
typealias solana = TestSeed.Solana

extension TestSeed {
    static func keys<A:Address>(_ type: A.Type) -> [Keys] {
        if type == EthereumAddress.self {
            return [
                (ethereum.private_key_0, "", ethereum.address_0),
                (ethereum.private_key_1, "", ethereum.address_1)
            ]
        } else if type == BitcoinAddress.self {
            return [
                (bitcoin.private_key_0, bitcoin.public_key_0, bitcoin.address_0),
                (bitcoin.private_key_1, bitcoin.public_key_1, bitcoin.address_1)
            ]
        } else if type == LitecoinAddress.self {
            return [
                (litecoin.private_key_0, litecoin.public_key_0, litecoin.address_0),
                (litecoin.private_key_1, litecoin.public_key_1, litecoin.address_1)
            ]
        } else if type == DogecoinAddress.self {
            return [
                (doge.private_key_0, doge.public_key_0, doge.address_0),
                (doge.private_key_1, doge.public_key_1, doge.address_1)
            ]
        } else if type == SolanaAddress.self {
            return [
                (solana.private_key_0, solana.public_key_0, solana.address_0)
            ]
        } else {
            return []
        }
    }
    
    static func key<A:Address>(_ type: A.Type) -> Keys {
        if let first = keys(type).first {
            first
        }else {
            ("","","")
        }
    }
}
