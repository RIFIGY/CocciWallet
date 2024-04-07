
import XCTest
import Web3Kit
@testable import ChainKit

final class AccountTests: XCTestCase {
    func testImportEthereumAccount() {
        let privateKey = "0x81033d424a3198903297e50d17740f56609d179d0b225c72f116ce81e1396ab4"
        let expectedAddress = "0x62259Bc0ae16fF38Ed0968d988629219f7093583"
        let storage = TestStorage(privateKey: privateKey, address: expectedAddress)

        do {
            let account = try EthereumAccount.importAccount(into: storage, privateKey: privateKey, keystorePassword: "")
                        
            let expectedAddress = EthereumAccount.Address(expectedAddress)

            XCTAssertEqual(account.address, expectedAddress, "Derived Ethereum address does not match the expected address")

        } catch {
            XCTFail("Expected Imported Ethereum Account \(error)")
        }

    }
}

fileprivate class TestStorage: PrivateKeyStorageProtocol {

    
    private var key: (privateKey: String, address: String)
    

    init(privateKey: String, address: String) {
        self.key = (privateKey, address)
        
    }
    
    func loadPrivateKey<A:Address>(for address: A) throws -> Data {
        let privateKey = try EthereumAccount<A>.importPrivateKey(key.privateKey, keystorePassword: "")
        return try KeystoreUtil.encode(EthereumAccount<A>.self, privateKey: privateKey, password: "")

    }
    
    
    func storePrivateKey<A:Address>(key: Data, with _: A) throws {
//        self.privateKeys.append(key)
    }
    
    func fetchAccounts<A>(_ address: A.Type) throws -> [A] where A : ChainKit.Address {
        [
            A(key.address)
        ]
    }
    
    func deletePrivateKey<A>(for _: A) throws where A : ChainKit.Address {
        
    }
        

    func deleteAllKeys<A>(_ address: A.Type) throws where A : ChainKit.Address {
        
    }

}
