////
////  CocciWalletTests.swift
////  CocciWalletTests
////
////  Created by Michael Wilkowski on 3/23/24.
////
//
//import XCTest
//import KeychainSwift
//import web3
//import Web3Kit
//@testable import CocciWallet
//
//
//final class CocciWalletTests: XCTestCase {
////    var client: Web3Kit.EthereumClientProtocol!
//    var keyStore: (any WalletStore)!
//    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//    
//    
//    override func setUp() {
//        super.setUp()
////        client = EthereumClient(rpc: TestConfig.localRPC, chain: TestConfig.localChain)
//        keyStore = KeychainSwift()
//    }
//    
//
//    func testStorage() {
//        
//        do {
//            let account = try web3.EthereumAccount.create(addingTo: keyStore, keystorePassword: "")
//            let address = account.address.asString()
//            let allAccounts = try keyStore.fetchAccounts()
//            print(allAccounts.map{$0.asString()})
//            XCTAssertTrue(allAccounts.count > 1)
//            XCTAssert(address.count > 10)
//        } catch {
//            XCTFail("Expected an Ethereum Address and account to be create")
//            print(error)
//        }
//    }
//    
//    func testNewRetreive() {
//        
//        do {
//            let account = try web3.EthereumAccount.create(addingTo: keyStore, keystorePassword: "")
//            let address = account.address
//            
//            let retreival = try EthereumAccount(addressString: address.asString(), keyStorage: keyStore, keystorePassword: "")
//            let retreivalAddress = retreival.address
//            
//            XCTAssertEqual(address.asString(), retreivalAddress.asString())
//        } catch {
//            XCTFail("Expected to retreive correct Ethereum Account")
//        }
//    }
//    
//    func testRetreive() {
//        
//        do {
//            let account = try EthereumAccount.importAccount(addingTo: keyStore, privateKey: "0x82628753c31be7841848a11c164e38729b28277ecec5b187916d1bb21e95cf54", keystorePassword: "")
//            let address = account.address
//            
//            let retreival = try EthereumAccount(addressString: address.asString(), keyStorage: keyStore, keystorePassword: "")
//            let retreivalAddress = retreival.address
//            
//            XCTAssertEqual(address.asString(), retreivalAddress.asString())
//        } catch {
//            XCTFail("Expected to retreive correct Ethereum Account")
//        }
//    }
//
//}
//
//
