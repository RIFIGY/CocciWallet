////
////  File.swift
////  
////
////  Created by Michael Wilkowski on 3/26/24.
////
//
//import Foundation
//
//public extension Infura {
//    enum Chain: String, Identifiable, CaseIterable {
//        public var id: String { rawValue }
//        case mainnet, sepolia, goerli
//        case polygon
//        case arbitrum
//        case avalanche
//
//        public init?(chainId: Int) {
//            switch chainId {
//            case 1:
//                self = .mainnet
//            case 11155111:
//                self = .sepolia
//            case 5:
//                self = .goerli
//            case 137:
//                self = .polygon
//            case 42161:
//                self = .arbitrum
//            case 43114:
//                self = .avalanche
//            default:
//                return nil
//            }
//        }
//        
//        public var name: String {
//            switch self {
//            case .polygon:
//                "\(rawValue)-mainnet"
//            case .arbitrum:
//                "\(rawValue)-mainnet"
//            case .avalanche:
//                "\(rawValue)-mainnet"
//            default: rawValue
//            }
//        }
//        
//        public var symbol: String {
//            switch self {
//            case .sepolia:
//                return "sepoliaETH"
//            case .goerli:
//                return "goerliETH"
//            case .polygon:
//                return "MATIC"
//            case .avalanche:
//                return "AVAX"
//            default:
//                return "ETH"
//            }
//        }
//    }
//
//}
