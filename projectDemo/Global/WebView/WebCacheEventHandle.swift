//
//  WebCacheEventHandle.swift
//  projectDemo
//
//  Created by Cheng on 2022/4/27.
//

import UIKit
import Cache

class WebCacheEventHandle: NSObject {

//    static let shared = WebCacheEventHandle()
    
    override init() {
        super.init()
    }
}

extension WebCacheEventHandle {
    
    public static func setWebValue(value: String?, for Key: String) {
        
        UserDefaults.standard.setValue(value, forKey: Key)
    }
    
    public static func getWebValueForKey(key: String) -> String? {
        
        if let value = UserDefaults.standard.value(forKey: key) as? String {
            return value
        }
        return nil
    }
    
    public static func removeValueForKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
