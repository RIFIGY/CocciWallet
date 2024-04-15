//
//  File.swift
//  
//
//  Created by Michael on 4/13/24.
//

import Foundation
import web3
import BigInt
import OffChainKit

extension BigUInt {
    func double(_ decimals: UInt8) -> Double {
        let divisor = BigUInt(10).power(Int(decimals))
        return Double(self) / Double(divisor)
    }
}


public class EthClient {
    typealias Account = EthereumAccount
    typealias Address = EthereumAddress
        
    private let client: EthereumHttpClient
    private let erc20: web3.ERC20
    private let erc721Metadata: web3.ERC721Metadata
    public var rpc: URL { client.rpc }
    public var chain: Int { client.chain }
    
    public init(rpc: URL, chain: Int){
        let client = EthereumHttpClient(url: rpc, network: .custom(chain.description))
        self.client = client
        self.erc20 = .init(client: client)
        self.erc721Metadata = .init(client: client, metadataSession: .shared)
    }
    

    public func fetchNativeBalance(for address: String, decimals: UInt8) async throws -> Double {
        let balance = try await client.eth_getBalance(address: .init(address), block: .Latest)
        return balance.double(decimals)
    }
    
    public func fetchContract<T:ERC20P>(for address: String) async throws -> T {
        let contract = EthereumAddress(address)
        print(contract)
        async let name: String = try await erc20.name(tokenContract: contract)
        async let symbol: String = try await erc20.symbol(tokenContract: contract)
        async let decimals: UInt8 = try await erc20.decimals(tokenContract: contract)

        return try await T(
            address: contract.string,
            name: name,
            symbol: symbol,
            decimals: decimals
        )
    }
    
    public func fetchNFT<N:NFTP>(tokenId: String, contract: EthereumAddress) async -> N {
        let uri = try? await erc721Metadata.tokenURI(contract: contract, tokenID: .init(stringLiteral: tokenId))
        let emptyNFT = N(tokenId: tokenId.description, contract: contract.string, uri: uri, metadata: nil, imageURL: nil)

        guard let uri else {
            return emptyNFT
        }
        let gateway = IPFS.Gateway(uri)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 2 // seconds
        let session = URLSession(configuration: config)
        do {
            let (data, _) = try await session.data(from: gateway)
            let metadata = try? JSONDecoder().decode(OpenSeaMetadata.self, from: data)
            let imageUrl = URL(string: metadata?.image ?? "")
            return N(tokenId: tokenId.description, contract: contract.string, uri: uri, metadata: data, imageURL: imageUrl)
        } catch {
            return emptyNFT
        }
    }
    
    
    public func fetchTokenBalance(contract: String, address: String) async throws -> BigUInt {
        let balance = try await erc20.balanceOf(tokenContract: .init(contract), address: .init(address))
        return balance

    }
    
    public func fetchTokenInteractions(for address: String) async throws -> [String] {
        let interactions = try await client.getTransferEvents(for: .init(address))
        return Array(Set(interactions.map{$0.contract.string}))
    }
    
    public func fetchContractBalance<T:ERC20P>(contract: String, address: String) async throws -> (T, Double?) {
        let token: T = try await self.fetchContract(for: contract)
        let balance = try? await self.erc20.balanceOf(tokenContract: .init(contract), address: .init(address))
        let value = balance?.double(token.decimals ?? 18)
        return (token, value)

    }
    
    public func fetchTokenBalances<T:ERC20P>(interactions contracts:[String], address: String) async throws -> [ (T,Double?) ] {
        
        return await withTaskGroup(of: (T,Double?)?.self) { group in
            contracts.forEach { contract in
                let contract = EthereumAddress(contract)
                group.addTask {
                    do {
                        let (token, balance): (T,Double?)  = try await self.fetchContractBalance(contract: contract.asString(), address: address)
                        return (token, balance)
                    } catch {
                        return nil
                    }
                }
            }
            
            return await group.reduce(into: [(T, Double?)]()) { partialResult, result in
                if let result {
                    partialResult.append(result)
                }
            }
        }
    }
    
    
    public func fetchNFTHoldings(for address: String) async throws -> [EthereumAddress : [BigUInt] ] {
        let interactions = try await client.getTokenTransferEvents(for: .init(address))
        let dict = filter(transfers: interactions, for: .init(address))
        return dict
    }
    
    public func fetchNFTs<N:NFTP>(holdings dict: [EthereumAddress : [BigUInt] ]) async throws -> [N] {
        await withTaskGroup(of: N.self) { group in
            dict.forEach { contract, tokenIds in
                tokenIds.forEach { tokenId in
                    group.addTask {
                        await self.fetchNFT(tokenId: tokenId.description, contract: contract)
                    }
                }
            }
            
            return await group.reduce(into: [N]()) { partialResult, nft in
                partialResult.append(nft)
            }
        }
        
    }
    
    
}

public protocol ERCP {
    var decimals: UInt8? {get}
    init(address: String, name: String, symbol: String?, decimals: UInt8?)
}

public typealias ERC20P = ERCP
public typealias ERC721P = ERCP

public protocol NFTP: Codable {
    init(tokenId: String, contract: String, uri: URL?, metadata: Data?, imageURL: URL?)
}

fileprivate func filter(transfers: [any ERC721TransferProtocol], for address: EthereumAddress) -> [EthereumAddress: [BigUInt]] {
    var currentHeldNFTs: [EthereumAddress: [BigUInt]] = [:]
    var ownershipChanges: [String: String] = [:] // Tracks the most recent owner of each NFT.

    for transfer in transfers {
        let contract = transfer.contract.string.lowercased()
        let tokenId = transfer.tokenId
        let transferKey = "\(contract)_\(tokenId)"
        // Update the latest known owner of the NFT.
        ownershipChanges[transferKey] = transfer.to.string.lowercased()
    }
    
    // After processing all transfers, determine which NFTs are currently held by the address.
    for (key, currentOwner) in ownershipChanges {
        let components = key.components(separatedBy: "_")
        guard components.count == 2, let contractString = components.first, let tokenIdString = components.last, let tokenId = BigUInt(tokenIdString) else {
            continue
        }

        let contract = EthereumAddress(contractString)
        if currentOwner == address.string.lowercased() {
            // If the address is the current owner, add the NFT to the currentHeldNFTs.
            if currentHeldNFTs[contract] != nil {
                currentHeldNFTs[contract]?.append(tokenId)
            } else {
                currentHeldNFTs[contract] = [tokenId]
            }
        } else {
        }
    }

    return currentHeldNFTs
}
