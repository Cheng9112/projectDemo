//
//  WebViewBaseScriptEvent.swift
//  projectDemo
//
//  Created by 陈鸿城 on 2022/4/21.
//

import UIKit
import Alamofire

class WebViewBaseScriptEvent: NSObject {
    
    /// 关闭当前WebView
    @objc func closeWebView( _ arg: String) -> Void {
    
        if let nav = getCurrentViewController() as? UINavigationController {
            nav.popViewController(animated: true)
        } else if let vc = getCurrentViewController() {
            vc.dismiss(animated: true)
        }
    }
    
    /// 打开新的WebView
    @objc func openNewWebView( _ arg: String) -> Void {
        
        let webVC = WebViewController()
        webVC.loadRequest(urlString: arg)
        if let nav = getCurrentViewController() as? UINavigationController {
            nav.pushViewController(webVC, animated: true)
        } else if let vc = getCurrentViewController() {
            vc.present(webVC, animated: true, completion: nil)
        }
    }
    
    /// 打开新的WebView
    @objc func clearWebCache( _ arg: String) -> Void {
        WebViewController.removeWebSiteCache()
    }
    
    /// 日志打印log
    @objc func webLogDebug( _ arg: String) -> Void {
        
    }
    
    /// 日志打印Info
    @objc func webLogInfo( _ arg: String) -> Void {
        
    }
    
    /// 根据Key增删查
    @objc func updateValue( _ arg: NSDictionary) -> Void {
        if let key = arg["key"] as? String, let value = arg["value"] as? String {
            WebCacheEventHandle.setWebValue(value: value, for: key)
        }
    }
    @objc func removeValue( _ arg: NSDictionary) -> Void {
        if let key = arg["key"] as? String {
            WebCacheEventHandle.removeValueForKey(key: key)
        }
    }
    @objc func getValue( _ arg: NSDictionary, handler: (String, Bool)->Void) {
        if let key = arg["key"] as? String, let value = WebCacheEventHandle.getWebValueForKey(key: key) {
            handler(value, true)
        }
    }
    
    /// 打开第三方链接
    @objc func openUrl( _ arg: String) -> Void {
        if arg.count > 0, let url = URL.init(string: arg) {
            UIApplication.shared.open(url)
        }
    }
    
    /// 复制文案
    @objc func copyText( _ arg: String, handler: (String, Bool)->Void) {
        if arg.count > 0 {
            let text = arg.removingPercentEncoding
            UIPasteboard.general.string = text
            handler("1", true)
        }
    }
    
    /// 获取通知权限
    /// 获取定位权限
    /// 图片下载
    /// 视频下载
    /// 获取网络状态

    
    ///----业务模块----
    /// 获取App Cookie

}

extension WebViewBaseScriptEvent {
    
    /// 获取当前控制器
    private func getCurrentViewController() -> UIViewController? {
            
        if let window = UIApplication.shared.delegate?.window, let vc = window?.rootViewController {
            
            if let tab = vc as? UITabBarController  {
                
                return tab.selectedViewController
                
            } else if let nav = vc as? UINavigationController {
                
                return nav
            }
        }
        return nil
    }
}
