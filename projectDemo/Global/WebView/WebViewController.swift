//
//  WebViewController.swift
//  projectDemo
//
//  Created by 陈鸿城 on 2022/3/19.
//

import UIKit
import WebKit
import dsBridge

class WebProcessPool: WKProcessPool {
    
    static var shared: WebProcessPool = {
        let instance = WebProcessPool()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WebViewController: UIViewController {
    
    /// 当前request
    private(set) var currentRequest: URLRequest?
    /// 原本的request
    private(set) var originalRequest: URLRequest?
    /// 是否结束加载
    private(set) var finishLoad: Bool = true
    /// 白屏加载次数
    private var reloadCount: Int = 0
    /// 白屏加载链接
    private var terminateUrlStr: String = ""
    /// web容器
    private lazy var dwkWebView: DWKWebView = initWebView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        dwkWebView.navigationDelegate = nil
        dwkWebView.uiDelegate = nil
        dwkWebView.stopLoading()
        dwkWebView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(dwkWebView)
        dwkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
// MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url, allowLoadingURL(url: url) {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        finishLoad = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishLoad = true
        LogInfo("didFinishNavigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        finishLoad = true
        LogInfo("didFailProvisionalNavigation url:\(webView.url?.absoluteString ?? "default") \nl error:\(error)")
    }
    
    /// 当web进程即将崩溃时调用，用于刷新页面防止白屏
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
        if terminateUrlStr != webView.url?.absoluteString {
            reloadCount = 0
            terminateUrlStr = webView.url?.absoluteString ?? ""
        }
        if reloadCount <= 5 {
            webView.reload()
            reloadCount += 1
        }
    }
}

// MARK: WKUIDelegate
extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

// MARK: Private Method
extension WebViewController {
    
    private func initWebView() -> DWKWebView {
        
        let configuration = WKWebViewConfiguration.init()
        configuration.allowsInlineMediaPlayback = true          ///设置HTML5视频是否允许网页播放 设置为NO则会使用本地播放器
        configuration.selectionGranularity = .character         ///设置请求的User-Agent信息中应用程序名称 iOS9后可用
        configuration.allowsAirPlayForMediaPlayback = true      ///设置是否允许ariPlay播放
        configuration.suppressesIncrementalRendering = false    ///设置是否将网页内容全部加载到内存后再渲染
        configuration.processPool = WebProcessPool.shared       ///web内容处理池
        
        let userContentController = WKUserContentController.init()
        configuration.userContentController = userContentController
//        if #available(iOS 11.0, *), let cookie = getUserCookie() {
//            WebViewController.setCookie(cookie: cookie)
//        } else if let cookie = getUserCookie() {
//            WebViewController.setCookie(cookie: cookie)
//            setCookieByScript(cookie: cookie, userContentcontroller: userContentController)
//        }
        
        let webview = DWKWebView.init(frame: CGRect.zero, configuration: configuration)
        webview.scrollView.bounces = false
        webview.backgroundColor = .clear
        webview.isOpaque = false
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.navigationDelegate = self
        webview.uiDelegate = self
        ///适配H5页面键盘唤起不回弹
        if #available(iOS 11.0, *) {
            if #available(iOS 12.0, *) {
                webview.scrollView.contentInsetAdjustmentBehavior = .automatic
            } else {
                webview.scrollView.contentInsetAdjustmentBehavior = .never
            }
        }
        return webview
    }
    
    /// 是否允许加载链接
    private func allowLoadingURL(url: URL) -> Bool {
        
        if let scheme = url.scheme, scheme == "http" || scheme == "https" {
            return true
        }
        return false
    }
    
    /// 获取当前app Cookie
    private func getUserCookie() -> HTTPCookie? {
        
        let cookieProperty: [HTTPCookiePropertyKey : Any] = [
            HTTPCookiePropertyKey.name: "cookie",
            HTTPCookiePropertyKey.value: "1111",
            HTTPCookiePropertyKey.domain: originalRequest?.url?.host ?? "" ,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.expires: Date.init(timeIntervalSinceNow: 2629743)
        ]
        let cookie = HTTPCookie.init(properties: cookieProperty)
        return cookie
    }
}

// MARK: Public Method
extension WebViewController {
    
    /// 清除WkWebView 缓存
    @available(iOS 11.0, *)
    public static func removeWebSiteCache() {
        
        DispatchQueue.main.async {
            if #available(iOS 11.3, *) {
                let types = Set.init(arrayLiteral: WKWebsiteDataTypeFetchCache, WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeOfflineWebApplicationCache)
                WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: Date.init(timeIntervalSince1970: 0)) {}
            } else {
                let types = Set.init(arrayLiteral: WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeOfflineWebApplicationCache)
                WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: Date.init(timeIntervalSince1970: 0)) {}
            }
        }
    }
    
    /// 设置webView Cookies
    @available(iOS 11.0, *)
    public static func setCookie(cookie: HTTPCookie, _ completionHandler: (() -> Void)? = nil) {
        
        let wkWebsiteDataStore = WKWebsiteDataStore.default()
        let wkHttpCookieStore = wkWebsiteDataStore.httpCookieStore
        wkHttpCookieStore.setCookie(cookie) {
            /// cookie设置完成
            if (completionHandler != nil) {
                completionHandler!()
            }
        }
    }

    /// 加载链接
    public func loadRequest(urlString: String) {
        if let url = URL.init(string: urlString) {
            let urlRequest = URLRequest.init(url: url)
            currentRequest = urlRequest
            originalRequest = urlRequest
            dwkWebView.load(urlRequest)
        }
    }
    
    /// 通过script设置cookie
    public func setCookieByScript(cookie: HTTPCookie, userContentcontroller: WKUserContentController) {
        let path = cookie.path.isEmpty ? "/" : cookie.path
        var cookieStr = "\(cookie.name)=\(cookie.value);domain=\(cookie.domain);path=\(path)"
        if cookie.isSecure {
            cookieStr = cookieStr + ";secure=true"
        }
        let script = "var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n if (cookieNames.indexOf('\(cookie.name)') == -1) { document.cookie='\(cookieStr)'; };\n"
        let cookieInScript = WKUserScript.init(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentcontroller.addUserScript(cookieInScript)
    }
}
