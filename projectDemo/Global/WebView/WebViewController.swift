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
            
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private var webView: DWKWebView = {
        
        let configuration = WKWebViewConfiguration.init()
        configuration.allowsInlineMediaPlayback = true          ///设置HTML5视频是否允许网页播放 设置为NO则会使用本地播放器
        configuration.selectionGranularity = .character         ///设置请求的User-Agent信息中应用程序名称 iOS9后可用
        configuration.allowsAirPlayForMediaPlayback = true      ///设置是否允许ariPlay播放
        configuration.suppressesIncrementalRendering = false    ///设置是否将网页内容全部加载到内存后再渲染
        configuration.processPool = WebProcessPool.shared       ///web内容处理池
        
        var view = DWKWebView.init(frame: CGRect.zero, configuration: configuration)
        view.scrollView.bounces = false
        view.backgroundColor = .clear
        view.isOpaque = false
        view.scrollView.showsVerticalScrollIndicator = false
        view.scrollView.showsHorizontalScrollIndicator = false
        ///适配H5页面键盘唤起不回弹
        if #available(iOS 11.0, *) {
            if #available(iOS 12.0, *) {
                view.scrollView.contentInsetAdjustmentBehavior = .automatic
            } else {
                view.scrollView.contentInsetAdjustmentBehavior = .never
            }
        }
        return view
    }()

    private(set) var currentRequest: URLRequest?
    
    private(set) var originalRequest: URLRequest?
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url, allowLoadingURL(url: url) {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        

        return nil
    }
}

// MARK: PUBLIC
extension WebViewController {
    
    /// 清除WkWebView 缓存
    public static func removeWebSiteCache() {
        
        guard #available(iOS 11.0, *) else { return }
        
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

    /// 加载链接
    public func loadRequest(urlString: String) {
        if let url = URL.init(string: urlString) {
            let urlRequest = URLRequest.init(url: url)
            currentRequest = urlRequest
            originalRequest = urlRequest
            webView.load(urlRequest)
        }
    }
    
    /// 是否允许加载链接
    public func allowLoadingURL(url: URL) -> Bool {
        
        if let scheme = url.scheme, scheme == "http" || scheme == "https" {
            
            return true
        }
        return false
    }
}
