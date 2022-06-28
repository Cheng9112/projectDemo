//
//  LogFormatter.swift
//  projectDemo
//
//  Created by Cheng on 2022/6/28.
//

import Foundation
import CocoaLumberjack

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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
        let timezone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timezone
        let dateTime = formatter.string(from: Date.init())
        
        return "\(dateTime) \(logLevel) [\(logMessage.fileName) \(logMessage.function ?? "未知")] [Thread: \(queueThreadLabel(for: logMessage))]: \(logMessage.message)"
    }
}
