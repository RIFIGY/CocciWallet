//
//  AdditionalNftDetails.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import SwiftUI


struct Trait<C:Any>: Identifiable, Equatable, Hashable {
    static func == (lhs: Trait<C>, rhs: Trait<C>) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String { name }
    let name: String
    let value: C
}

struct AdditionalNftDetails: View {
    
    let details: [String:Any]
    
    init(details: [String : Any]) {
        self.details = details.filter {
            $0.0.lowercased() != "name" && $0.0.lowercased() != "description" && $0.0.lowercased() != "tokenid"
        }
    }

    @State private var selectedURL: Trait<URL>?

    
    var body: some View {
        if !URLs.isEmpty {
            AttributeGrid(items: URLs, columns: 4) { name, url in
                Button {
                    self.selectedURL = .init(name: name, value: url)
                } label: {
                    AttributeCell(name: name) {
                        Image(systemName: url.media.systemName)
                    }
                }
            }
            .sheet(item: $selectedURL) { trait in
                MediaView(url: trait.value, trait: trait.name)
            }
        }
        
        if !strings.isEmpty {
            AttributeGrid(strings: strings)
        }
    }
    

    var URLs: [(String, URL)] {
        details.compactMap { key, value in
            guard let stringValue = value as? String,
            let url = checkURL(string: stringValue) else {return nil}
            let name = key.replacingOccurrences(of: "_url", with: " ").replacingOccurrences(of: "_", with: " ").capitalized
            return (name, url)
        }
    }
    
    var strings: [ (String,String) ] {
        details.compactMap { key, value in
            guard let stringValue = value as? String else {return nil}
            if let _ = checkURL(string: stringValue) {
                return nil
            } else {
                return (key, stringValue)
            }
        }
    }
    
    fileprivate func checkURL(string: String) -> URL? {
        let url = URL(string: string)
        let scheme = url?.scheme
        let validScheme = ["http", "https", "ipfs"].contains(scheme)
        
        let hasHost = url?.host != nil
        
        return (validScheme && hasHost) ? url : nil
        
        
    }
    

}


extension URL: Identifiable {
    public var id: String {
        self.absoluteString
    }
}

#Preview {
    AdditionalNftDetails(details: [:])
}
