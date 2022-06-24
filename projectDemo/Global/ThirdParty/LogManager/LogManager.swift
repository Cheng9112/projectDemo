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
        
        if let DDTTY = DDTTYLogger.sharedInstance {
//            DDTTY.logFormatter = LogFormatter.init()
            DDLog.add(DDTTY, with: .all)
        }
                
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
        fileLogger.logFormatter = LogFormatter.init()
        DDLog.add(fileLogger, with: .all)
        
        DDLogVerbose("Verbose");
        DDLogDebug("Debug");
        DDLogInfo("Info");
        DDLogWarn("⚠️");
        DDLogError("Error");
    }
}

class LogFormatter: DDDispatchQueueLogFormatter {
    
    override func format(message logMessage: DDLogMessage) -> String? {
        
        var logLevel = ""
        switch logMessage.flag {
        case .debug:
            logLevel = "[Debug] >>>"
        case .error:
            logLevel = "[Error] >>>"
        case .info:
            logLevel = "[Info] >>>"
        case .verbose:
            logLevel = "[Verbose] >>>"
        case .warning:
            logLevel = "[Warning] >>>"
        default:
            logLevel = ""
        }
        
        return "\(logLevel) [\(logMessage.fileName) \(logMessage.function ?? "未知")] [line: \(logMessage.line)] [Thread: \(queueThreadLabel(for: logMessage))]: \(logMessage.message)"
    }
}
