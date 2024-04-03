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
    private(set) var tokenInfo: TokenVM<EthClient.Client>
    private(set) var nftInfo: NftVM<EthClient.Client>
    
    var lastUpdate: Date?
    var isUpdating = false
    
    public init(evm: EVM, address: String, decimals: UInt8 = 18) {
        self.chain = evm.chain
        self.rpc = evm.rpc
        self.settings = .init()
        self.tokenInfo = .init(address: address)
        self.nftInfo = .init(address: address)
        super.init(address: address, decimals: decimals, title: evm.name, symbol: evm.symbol, explorer: evm.explorer, hexColor: evm.hexColor, isCustom: evm.isCustom)
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
        tokenInfo = try container.decode(TokenVM<EthClient.Client>.self, forKey: ._tokenInfo)
        nftInfo = try container.decode(NftVM<EthClient.Client>.self, forKey: ._nftInfo)

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


    private var printer: String { title + ": " + address.suffix(5) }
    func update(with client: EthClient) async -> Bool {
        guard needUpdate(), !isUpdating else {return false}
        isUpdating = true
        print(printer)

        await withTaskGroup(of: Void.self) { group in
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
        print("Fetched \(printer)")
        return true
    }
    
    private func needUpdate() -> Bool {
        guard let lastUpdate = lastUpdate else { return true }
        return lastUpdate < Date.now.addingTimeInterval(-3600)
    }
    
    private func fetch(with client: any EthereumClientProtocol) async {
        do {
            self.balance = try await client.getBalance(address: address, block: nil)
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
