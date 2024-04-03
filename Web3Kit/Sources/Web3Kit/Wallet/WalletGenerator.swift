//
//  File.swift
//  
//
//  Created by Michael Wilkowski on 3/10/24.
//

import Foundation
import web3

public protocol WalletGeneratorProtocol {
    associatedtype W : Identifiable where W.ID == String

    var blockHD: String {get}
    
    func creatAccount(name: String, password: String) throws -> W.ID
    
    func importAccount(privateKey: String, password: String, name: String) throws -> W.ID
    
    func watchAddress(_ address: String, name: String) throws -> W.ID
    
    func validate(address: String) -> Bool
}



public class EthereumWalletGenerator<W:Identifiable>: WalletGeneratorProtocol where W.ID == String {
        
    public typealias Storage = EthereumMultipleKeyStorageProtocol
    public let storage: any Storage
    
    public let blockHD: String = "ETH"
    
    public init(storage: Storage) {
        self.storage = storage
    }
    
    public func validate(address: String) -> Bool {
        let data = address.web3.hexData
        return data != nil
    }
    
    public func creatAccount(name: String, password: String) throws -> String {
        let account = try EthereumAccount.create(addingTo: storage, keystorePassword: password)
        return account.address.asString()
    }
    
    public func importAccount(privateKey: String, password: String, name: String) throws -> String {
        let account = try EthereumAccount.importAccount(addingTo: storage, privateKey: privateKey, keystorePassword: password)
        return account.address.asString()
    }
    
    public func watchAddress(_ address: String, name: String) throws -> String {
        guard validate(address: address) else {
            throw Error.invalidAddress
        }
        return address
    }
    
    public enum Error: Swift.Error {
        case invalidAddress
    }
}
 
public extension String {
    var isEthereumAddress: Bool {
        self.web3.isAddress
    }
}
