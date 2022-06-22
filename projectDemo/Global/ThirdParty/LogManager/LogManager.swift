//
//  LogManager.swift
//  projectDemo
//
//  Created by Chengshan Li on 2022/6/9.
//

import Foundation
import CocoaLumberjack


class LogManager {
    
    init() {
        
        DDLog.add(DDTTYLogger.sharedInstance ?? DDOSLogger.sharedInstance) // Uses os_log
        
        let path = NSHomeDirectory() + "Library/cache/log"
        let logFileManagerDefault = DDLogFileManagerDefault(logsDirectory: path)
        
        let fileLogger: DDFileLogger = DDFileLogger.init(logFileManager: logFileManagerDefault) // File Logger
        // 日志文件个数
        fileLogger.logFileManager.maximumNumberOfLogFiles = 1000
        // 日志文件夹限制
        fileLogger.logFileManager.logFilesDiskQuota = 20 * 1024 * 1024
        // 日志文件采集区间 设置24小时 因为不同天肯定会创建新文件
        fileLogger.rollingFrequency = 60 * 60 * 24
        // 单个日志文件最大限制
        fileLogger.maximumFileSize = 2 * 1024 * 1024
        // 每次重新启动APP就建立日志文件
        fileLogger.doNotReuseLogFiles = true
        
        DDLog.add(fileLogger)
    }
}

//MARK: - Private
extension LogManager {

}
