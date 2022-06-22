//
//  AppInfo.swift
//  projectDemo
//
//  Created by Cheng on 2022/6/21.
//

import Foundation

class AppInfo {
    
    ///获取当前客户端的版本
    public static func appVersion() -> String  {
        if let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dic = plist as? [String: Any],
           let versionString = dic["CFBundleShortVersionString"] as? String {
            
            return versionString
        }
        return "未知版本";
    }
    
}
