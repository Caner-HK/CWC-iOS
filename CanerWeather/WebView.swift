//
//  CanerWeatherApp.swift
//  CanerWeather
//
//  Created by Kent Ye (Caner Developer Team) on 2024/1/21.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // 设置navigationDelegate为Coordinator
        
        // 获取并设置自定义User-Agent
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let userAgent = result as? String {
                webView.customUserAgent = userAgent + " CanerWeatherIOS/0.0.2-Pre"
                // 由于User-Agent是异步设置的，实际的URL加载需要在设置完成后进行
                let request = URLRequest(url: self.url)
                webView.load(request)
            }
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 由于User-Agent的设置在makeUIView中异步完成，这里通常不需要重新加载请求
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }
}

