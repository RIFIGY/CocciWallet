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

@Observable
class NetworkTest: Identifiable, Codable {
    let evm: EVM
    let address: String
    var lastUpdate: Date?
    var isUpdating = false
    var decimals: UInt8 = 18
    var nativeBalance: BigUInt?
    var transactions: [Etherscan.Transaction] = []
}

@Observable
class NetworkCard {
    let evm: EVM
    let address: String
    var lastUpdate: Date?
    var isUpdating = false

//    fileprivate let walletInfo: WalletVM
    fileprivate let tokenInfo: TokenVM
    fileprivate let nftInfo: NftVM
    
    init(evm: EVM, address: String) {
        self.address = address
        self.evm = evm

        self.tokenInfo = .init(address: address)
        self.nftInfo = .init(address: address)
    }

    func update(with client: EthereumClient?, address: String) async {
        guard let client else {return}
        let suffix = address.suffix(5)
        guard lastUpdate == nil, !isUpdating else {return}
        isUpdating = true
        print("\(name): \(suffix) ")
        await fetchNativeBalance(with: client)
        await fetchTransactions(for: evm)

        print("ERC20: \(suffix) \(name)")
        await tokenInfo.fetch(with: client)
        print("ERC721: \(suffix) \(name)")
        await nftInfo.fetch(with: client)
        self.lastUpdate = .now
        self.isUpdating = false
        print("Done updating \(suffix) \(name)")
    }
    
    
    private func fetchNative(for evm: EVM, with client: any EthereumClientProtocol) async {
        await fetchTransactions(for: evm)
        await fetchNativeBalance(with: client)
    }
        
    
    private func fetchTransactions(for evm: EVM) async {
        do {
            let allTxs = try await Etherscan.shared.getTransactions(for: address, evm: evm)
            print("\t\(evm.name!)TXs: \(allTxs.count.description)")
            self.transactions = allTxs
        } catch {
            print(error)
        }
    }
    
    private func fetchNativeBalance(with client: any EthereumClientProtocol) async {
        do {
            let balance = try await client.getBalance(address: address, block: nil)
            self.nativeBalance = balance
        } catch {
            print(error)
        }
    }
    
    var name: String { evm.name ?? evm.chain.description }
    
    var decimals: UInt8 = 18
    var nativeBalance: BigUInt?
    var transactions: [Etherscan.Transaction] = []
    var balance: Double? { nativeBalance?.value(decimals: decimals) } /*{ walletInfo.balance }*/

    
    var erc20Interactions: [String] { tokenInfo.contractInteractions }
//    var tokenBalances: [ERC20 : BigUInt] { tokenInfo.balances }
//    var tokenTransfers: [ERC20 : [ERC20Transfer]] { tokenInfo.transfers }
    
    var tokens: [ERC721 : [NftMetadata]] { nftInfo.tokens }
    var nfts: [NftMetadata] { nftInfo.nfts }
    var favorite: NftMetadata? { nftInfo.first }
    
    var color: Color { evm.color }
}

extension NetworkCard: Identifiable, Equatable, Hashable {
    static func == (lhs: NetworkCard, rhs: NetworkCard) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String { evm.id + "_" + address }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
fileprivate class TokenVM {
    var transfers: [ERC20 : [ERC20Transfer] ] = [:]
    var balances: [ERC20 : BigUInt] = [:]
    var events: [ERC20Transfer] = []
    
    let address: String
    
    init(address: String) {
        self.address = address
    }
    
    var contractInteractions: [String] {
        Array(Set(events.map{$0.contract}))
    }
    
    func reset(){
        self.events = []
        self.transfers = [:]
        self.balances = [:]
    }
    
    func fetch(with client: any ERC20Client) async {
        await fetchERC20Events(with: client)
        await fetchBalances(with: client)
        groupEvents()
    }
    
    private func fetchBalances(with client: any ERC20Client) async {
        do {
            let balances = try await client.fetchBalances(for: address, in: self.contractInteractions)
            balances.forEach { contract, balance in
                self.balances[contract] = balance
                self.transfers[contract] = []
            }
        } catch {
            print(error)
        }

    }
    
    
    private func fetchERC20Events(with client: any ERC20Client) async {
        do {
            let events = try await client.getERC20events(for: address)
            self.events = events
            print("\tTXs: \(events.count.description), Tokens: \(contractInteractions.count.description)")
        } catch {
            print(error)
        }
    }
    
    func groupEvents(){
        events.forEach { event in
            if let token = transfers.keys.first(where: {$0.contract.lowercased() == event.contract.lowercased()}) {
                transfers[token]?.append(event)
            }
        }
    }
    
}

@Observable
fileprivate class NftVM {
    let address: String
    typealias NFT = ERC721
    var transfers: [ERC721Transfer] = []
    var tokens: [ERC721: [NftMetadata]] = [:]
    
    var nfts: [NftMetadata] { tokens.flatMap{$0.value} }
    var first: NftMetadata? {
        nfts.first{ $0.imageUrl != nil }
    }
    init(address: String) {
        self.address = address
    }
    
    func reset(){
        self.transfers = []
        self.tokens = [:]
    }
    
    func fetch(with client: any ERC721Client) async {
        await fetchERC721Events(with: client)
        await fetchNFTs(with: client)
    }
    
    private func fetchNFTs(with client: any ERC721Client) async {
        do {
            let interactions = client.filter(transfers: self.transfers, for: address)
//            print("\tTXs: \(self.transfers.count.description), Contracts: \(interactions.keys.count), Tokens: \(interactions.values.reduce(0) { $0 + $1.count })")
            
            let nfts = try await client.fetchNFTs(in: interactions)
//            print("\tContracts: \(nfts.keys.count), Tokens: \(nfts.values.reduce(0) { $0 + $1.count })")
            
            await loadNFTs(with: nfts)

        } catch {
            print(error)
        }
    }
    
    private func loadNFTs(with tokens: [ERC721 : [ERC721.Token]]) async {
        let dict:[ERC721 : [NftMetadata]] = await withTaskGroup(of: NftMetadata.self) { group in
            tokens.forEach { _, tokenIds in
                tokenIds.forEach { token in
                    group.addTask {
                        let nft = NftMetadata(nft: token)
                        await nft.fetch()
                        return nft
                    }
                }
            }
            
            let nfts = await group.reduce(into: [NftMetadata]()) { partialResult, token in
                partialResult.append(token)
            }
            return Dictionary(grouping: nfts, by: { $0.erc721 })
        }
        self.tokens = dict
    }
    
    private func fetchERC721Events(with client: any ERC721Client) async {
        do {
            let events = try await client.getERC721TransferEvents(for: address)
            self.transfers = events
        } catch {
            print(error)
        }
    }
}
