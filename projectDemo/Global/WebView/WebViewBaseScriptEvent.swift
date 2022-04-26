//
//  WebViewBaseScriptEvent.swift
//  projectDemo
//
//  Created by 陈鸿城 on 2022/4/21.
//

import UIKit
import AFNetworking

class WebViewBaseScriptEvent: NSObject {

    /// 获取App Cookie
    @objc func getTicket( _ arg: String) -> Void {
        
        
    }
    
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
    
    /// 获取网络状态
    @objc func getNetworkStatus( _ arg: String, handler: (String, Bool)->Void) {
        let status = AFNetworkReachabilityManager.shared().networkReachabilityStatus
        handler(String.init(format: "%ld", status.rawValue), true)
    }
}

extension WebViewBaseScriptEvent {
    
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
