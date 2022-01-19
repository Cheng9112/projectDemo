//
//  GlobalManager.swift
//  projectDemo
//
//  Created by Cheng on 2021/11/15.
//

import Foundation

class GlobalManager: NSObject {
    
    init(installed: Bool) {
        super.init()
        if installed {
            
            DDLog.add(DDOSLogger.sharedInstance) // Uses os_log

            let fileLogger: DDFileLogger = DDFileLogger() // File Logger
            fileLogger.logFileManager.maximumNumberOfLogFiles = 100
            DDLog.add(fileLogger)
        }
    }
}
