//
//  NFTIntent.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/30/24.
//

import Foundation
import AppIntents
import WidgetKit



struct NFTIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "NFT"
    static var description = IntentDescription("Display NFT")
    
    @Parameter(title: "Random NFT", default: false)
    var randomNFT: Bool
   
    @Parameter(title: "Refresh Rate", default: .minute)
    var interval: RefreshInterval
    
    @Parameter(title: "Frequency", default: 30)
    var frequency: Int
    
    @Parameter(title: "Wallet")
    var wallet: WalletEntity
    
    @Parameter(title: "Network")
    var network: NetworkEntity?
    
    @Parameter(title: "Contract", query: NftContractQuery())
    var contract: ContractEntity?
    
    @Parameter(title: "NFT")
    var nft: NFTEntity?
    
    @Parameter(title: "NFTs", default: [], size: 3)
    var nfts: [NFTEntity]?
    
    @Parameter(title: "Show Network Background", default: false)
    var showBackground: Bool
    
    @Parameter(title: "Show Network Badge", default: false)
    var showNetwork: Bool
    
    
    static var parameterSummary: some ParameterSummary {
        When(widgetFamily: .oneOf, [.systemLarge, .systemMedium]) {
            When(\.$randomNFT, .equalTo, true) {
                When(\.$wallet, .hasAnyValue) {
                    Summary {
                        \.$randomNFT
                        \.$wallet
                        \.$network
                    }
                } otherwise: {
                    Summary {
                        \.$randomNFT
                        \.$wallet
                    }
                }
            } otherwise: {
                Summary {
                    \.$randomNFT
                    \.$wallet
                    \.$network
                    \.$contract
                    \.$nft
                    \.$nfts
                }
            }
        } otherwise: {
            When(\.$randomNFT, .equalTo, true) {
                When(\.$wallet, .hasAnyValue) {
                    Summary {
                        \.$randomNFT
                        \.$wallet
                        \.$network
                    }
                } otherwise: {
                    Summary {
                        \.$randomNFT
                        \.$wallet
                    }
                }
            } otherwise: {
                Summary {
                    \.$randomNFT
                    \.$wallet
                    \.$network
                    \.$contract
                    \.$nft
                }
            }
        }


    }

}


enum RefreshInterval: String, AppEnum {
    
    case minute
    case hour
    case day

    static var typeDisplayName: LocalizedStringResource = "Refresh Interval"
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Refresh Interval"

    static var caseDisplayRepresentations: [RefreshInterval: DisplayRepresentation] = [
        .minute: "Minute",
        .hour: "Hour",
        .day: "Day"
    ]
    
    var component: Calendar.Component {
        switch self {
        case .minute: .minute
        case .hour: .hour
        case .day: .day
        }
    }
}


