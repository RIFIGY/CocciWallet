//
//  ExploreView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/8/24.
//

import SwiftUI

struct ExploreView: View {
    
    let wallet: Wallet
    
//    var typedData: TypedData {
//        try! JSONDecoder().decode(TypedData.self, from: noDomain)
//    }
//    
    private let message = "Test Signature"
    @State private var signature: String?
    @State private var notes = ""
    
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text(message)
            TextField("Notes", text: $notes)
            TextField("Password", text: $password)
            
            Button("Sign"){
//                sign()
            }
            if let signature {
                Text(signature)
            }
        }
        
    }

    
//    func sign() {
//        Task {
//            do {
//                if let account = await manager.fetchAccount(generator: EthereumAccount.self, for: wallet, password: password) {
//                    let signature = try account.signMessage(message: typedData)
//
////                    let signature = try account.sign(message: message)
////                    printPrettyJSON(signature)
//                    let string = signature
//                    print(string)
//                    self.signature = string
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
}

//#Preview {
//    ExploreView(wallet: .rifigy)
//}
