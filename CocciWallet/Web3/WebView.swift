//
//  WebView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//


import SwiftUI

struct WebLink: View {
    let url: URL
    
    @State private var showLink = false

    var body: some View {
        #if os(iOS)
        Button("Etherscan Details") {
            showLink = true
        }
        .sheet(isPresented: $showLink) {
            WebView(url)
        }
        #else
        Link("Etherscan Details", destination: url)
        #endif
    }
}

#if os(iOS)
import WebKit


struct WebView: UIViewRepresentable {
    
    let initialUrl: URL?
    private let webView: WKWebView
    
    init(_ url: URL? = nil) {
        self.initialUrl = url
        self.webView = WKWebView()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.allowsBackForwardNavigationGestures = true
        if let initialUrl {
            webView.load(.init(url: initialUrl))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func goBack(){
        webView.goBack()
    }
    
    func goForward(){
        webView.goForward()
    }
    
    
    func loadURL(urlString: String) {
        webView.load(URLRequest(url: URL(string: urlString)!))
    }
}

#Preview {
    WebView()
}
#endif
