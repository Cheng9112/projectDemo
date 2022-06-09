//
//  GlobalManager.swift
//  projectDemo
//
//  Created by Cheng on 2021/11/15.
//

import Foundation
import CocoaLumberjack

class GlobalManager: NSObject {
    
    init(installed: Bool) {
        super.init()
        if installed {
            
            /// 日志打印
            let _ = LogManager.init(baseInfo: [:])
            
            /// 网络监控
            NetworkStatusManager.shared.networkReachablility { status in
                print(status)
            }
            
            /// 
        }
    }
}
