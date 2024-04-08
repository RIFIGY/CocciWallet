//
//  CardModel.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/16/24.
//

import Foundation
import Web3Kit
import SwiftUI
import BigInt
import OffChainKit

class NetworkCard: Network {
    var chain: Int
    var rpc: URL
    var settings: Settings
    private(set) var tokenInfo: TokenVM<EthereumClient.Client>
    private(set) var nftInfo: NftVM<EthereumClient.Client>
    
    
    public init(evm: EthereumNetwork, address: String, decimals: UInt8 = 18) {
        self.chain = evm.chain
        self.rpc = evm.rpc
        self.settings = .init()
        self.tokenInfo = .init(address: address)
        self.nftInfo = .init(address: address)
        super.init(network: evm)
    }
    
    enum CodingKeys: String, CodingKey {
        case _chain = "chain"
        case _rpc = "rpc"
        case _settings = "settings"
        case _tokenInfo = "tokenInfo"
        case _nftInfo = "nftInfo"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chain = try container.decode(Int.self, forKey: ._chain)
        rpc = try container.decode(URL.self, forKey: ._rpc)
        settings = try container.decode(Settings.self, forKey: ._settings)
        tokenInfo = try container.decode(TokenVM<EthereumClient.Client>.self, forKey: ._tokenInfo)
        nftInfo = try container.decode(NftVM<EthereumClient.Client>.self, forKey: ._nftInfo)

        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(chain, forKey: ._chain)
        try container.encode(rpc, forKey: ._rpc)
        try container.encode(settings, forKey: ._settings)
        try container.encode(tokenInfo, forKey: ._tokenInfo)
        try container.encode(nftInfo, forKey: ._nftInfo)
        
        try super.encode(to: encoder)
    }
    
}

extension NetworkCard {


    func update(with client: EthereumClient) async -> Bool {
        guard needUpdate(), !isUpdating else {return false}
        isUpdating = true

        await withTaskGroup(of: Void.self) { group in
            
            group.addTask {
                await self.fetchTransactions(for: "")
            }
            group.addTask {
                await self.fetch(with: client.node)
            }
            group.addTask {
                await self.tokenInfo.fetch(with: client.node)
            }
            group.addTask {
                await self.nftInfo.fetch(with: client.node)
            }
        }

        self.lastUpdate = .now
        self.isUpdating = false
        return true
    }
    
    
    private func fetch(with client: any EthereumClientProtocol) async {
        do {
            self.balance = try await client.getBalance(address: "", block: nil)
            print("\tBalance: " + (value?.string() ?? "0") )
        } catch {}
    }
}

extension NetworkCard {
    struct Settings: Codable {

        var showBalance = true
        var coverNFT: NftEntity? = nil

    }
}
