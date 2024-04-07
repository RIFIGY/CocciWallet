//
//  File.swift
//  
//
//  Created by Michael on 4/7/24.
//

import Foundation
public protocol SeedStorageProtocol {
    
    associatedtype I : Any
    
    func deleteAllSeeds() throws
    func fetchSeeds() throws -> [I]
    func deleteSeed(for _: I) throws
    func loadSeed(for _: I) throws -> Data
    func store(seed: Data, id: I) throws
}
