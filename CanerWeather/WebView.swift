//
//  CanerWeatherApp.swift
//  CanerWeather
//
//  Created by Kent Ye (Caner Developer Team) on 2024/1/21. Edited by Kent Ye (Caner Developer Team) on 2024/5/3.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true // If neeed it can play internal media

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        webViewConfiguration.defaultWebpagePreferences = preferences

        // Disallow zoom manually
        webViewConfiguration.userContentController.addUserScript(self.disableZoomScript())

        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.navigationDelegate = context.coordinator // Set navigationDelegate as Coordinator

        // Set custom User-Agent then load URL
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let userAgent = result as? String {
                webView.customUserAgent = "CanerWeatherIOS/0.0.3b67-Preview " + userAgent
                let request = URLRequest(url: self.url)
                webView.load(request)
            }
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Usually it is not necessary to reload the page
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

    // Disable-zooming JavaScript
    private func disableZoomScript() -> WKUserScript {
        let source: String = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}
