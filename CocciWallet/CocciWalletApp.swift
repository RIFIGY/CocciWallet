//
//  CocciWalletApp.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/3/24.
//

import SwiftUI
import SwiftData
import WalletData

@main
struct CocciWalletApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            WalletModelList()
        }
        .windowResizability(.contentSize)
        .modelContainer(WalletContainer.shared.container)
    }
}



//struct WalletModelList: View {
//    @Environment(\.modelContext) var modelContext
//    @Query(sort: \WalletModel.name) var wallets: [WalletModel]
//
//    @State private var addTapped = false
//    
//    @State private var address: String = ""
//    @State private var name: String = ""
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(wallets) { wallet in
//                    VStack {
//                        NavigationLink {
//                            NetworkModelList(wallet: wallet)
//                        } label: {
//                            Text(wallet.name + wallet.networks.count.description)
//
//                        }
////                            .foregroundStyle(wallet.color ? Color.red : Color.blue)
////                        Button("Toggle"){
////                            let model = NetworkModel(id: 11, name: "ETG222", wallet: wallet)
////                            self.modelContext.insert(model)
////                            wallet.color.toggle()
////                        }
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Add"){
//                        addTapped = true
//                    }
//                }
//            }
//            .navigationDestination(isPresented: $addTapped) {
//                VStack {
//                    TextField("Name", text: $name)
//                    TextField("Address", text: $address)
//                    Button("Done"){
//                        let model = WalletModel(address: .init(address), name: name)
//                        self.modelContext.insert(model)
//                    }
//                }
//            }
//        }
//    }
//}


//struct NetworkModelList: View {
//    @Environment(\.modelContext) var modelContext
//    let wallet: WalletModel
//    
//    @State private var addTapped = false
//    @State private var name: String = ""
//    @State private var chain: Int?
//
//    var body: some View {
//        VStack {
//            Button(wallet.networks.count.description){
//                wallet.color.toggle()
//            }
//            .foregroundStyle(wallet.color ? Color.red : Color.blue)
//            List {
//                ForEach(wallet.networks) { network in
//                    Text(network.name)
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Add"){
//                    addTapped = true
//                }
//            }
//        }
//        .navigationDestination(isPresented: $addTapped) {
//            VStack {
//                TextField("Name", text: $name)
//                TextField("Chain", value: $chain, format: .number)
//
//                Button("Done"){
//                    if let chain {
//                        let model = NetworkModel(chain: chain, name: name, address: wallet.address)
//                        wallet.networks.append(model)
//                        try? self.modelContext.save()
//                    }
//                }
//            }
//        }
//    }
//}
