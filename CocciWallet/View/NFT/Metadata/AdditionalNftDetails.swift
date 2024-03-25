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
    @State private var selectedURL: Trait<URL>?

    
    var body: some View {
        if let additionalURLs {
            AttributeGrid(items: urlList, collumns: 5) { name, url in
                let url = url as? URL
                let media = url?.media ?? .unknown
                let name = name.replacingOccurrences(of: "_url", with: " ").replacingOccurrences(of: "_", with: " ").capitalized
                return Button {
                    if let url {
                        self.selectedURL = .init(name: name, value: url)
                    }
                } label: {
                    AttributeGrid<EmptyView>.Cell(name: name) {
                        Image(systemName: media.systemName)
                    }
                }
            }
            .sheet(item: $selectedURL) { trait in
                MediaView(url: trait.value, trait: trait.name)
            }
        }
        
        if !additionalStrings.isEmpty {
            AttributeGrid(items: additionalStrings)
        }
    }
    
    
    var additionalURLs: [(name: String, url: URL)]? {
        details.compactMap { key, value in
            guard let stringValue = value as? String,
            let url = checkURL(string: stringValue) else {return nil}
            return (key, url)
        }
    }
    
    var additionalStrings: [ (String,String) ] {
        details.compactMap { key, value in
            guard let stringValue = value as? String else {return nil}
            if let url = checkURL(string: stringValue) {
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
    
    var urlList: [ (String, URL) ] {
        guard let additionalURLs else {return []}
        return additionalURLs.compactMap{ ($0.name, $0.url) }
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
