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
            
            /// 网络监控
            NetworkStatusManager.shared.networkReachablility { status in
                DDLogDebug("网络状态：\(status.statusStr)")
            }
            
            /// 日志打印
            let _ = LogManager.init()
            DDLogDebug(deviceInfoLog())
            DDLogDebug(appInfoLog())
            
            /// 
        }
    }
}

private extension GlobalManager {
    
    func deviceInfoLog() -> String {
        
        return """
        设备信息：
        系统版本：\(DeviceInfo.deviceSystemVersion())
        屏幕尺寸：\(DeviceInfo.deviceResolution())
        可用内存大小：\(DeviceInfo.deviceAvailableMemorySize())
        手机型号：\(DeviceInfo.deviceModel())
        当前设备IP：\(DeviceInfo.deviceIP())
        可用磁盘大小：\(DeviceInfo.deviceTotalDiskSize())
        """
    }
    
    func appInfoLog() -> String {
        
        return """
        App信息：
        App版本：\(AppInfo.appVersion())
        """
    }
}
