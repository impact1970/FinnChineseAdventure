import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        FinnWebView()
            .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct FinnWebView: UIViewRepresentable {
    private let productionURL = URL(string: "https://finn-chinese-adventure.vercel.app/")!

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = UIColor(
            red: 0.043, green: 0.071, blue: 0.188, alpha: 1
        )
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.allowsBackForwardNavigationGestures = true

        let request = URLRequest(
            url: productionURL,
            cachePolicy: .reloadRevalidatingCacheData,
            timeoutInterval: 30
        )
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            showOfflineMessage(in: webView)
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            showOfflineMessage(in: webView)
        }

        private func showOfflineMessage(in webView: WKWebView) {
            let html = """
            <html>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <body style="margin:0;background:#0b1230;color:white;font-family:-apple-system;
            display:flex;align-items:center;justify-content:center;height:100vh;text-align:center">
              <div style="padding:28px">
                <div style="font-size:56px">📶</div>
                <h2>目前無法連線</h2>
                <p style="color:#b8c2e8">請確認網路連線後，關閉 App 再重新開啟。</p>
              </div>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}
