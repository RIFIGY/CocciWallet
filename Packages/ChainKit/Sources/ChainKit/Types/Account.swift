//
//  File.swift
//  
//
//  Created by Michael on 4/4/24.
//

import Foundation
import Logging


public protocol AccountProtocol {
    associatedtype Address : ChainKit.Address
    var address: Address {get}
    
    static func importPrivateKey(_ _: String, keystorePassword _: String) throws -> Data
    static func displayPrivateKey(from _: Data) -> String
    static func generatePublicKey(from _: Data) throws -> Data
    
    init(addressString: String, keyStorage: any PrivateKeyStorageProtocol, keystorePassword password: String, logger: Logging.Logger?) throws
}


public enum AccountError: Error {
    case createAccountError
    case importAccountError
    case existingAccountError
    case loadAccountError
    case signError
    case invalidPrivateKeyFormat
}
