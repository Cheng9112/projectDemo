//
//  LocationBgTask.swift
//  projectDemo
//
//  Created by Cheng on 2021/11/23.
//

import Foundation

class LocationBgTask: NSObject {
    
    public static let shared = LocationBgTask()
    ///后台任务数组
    var bgTaskIdList = [UIBackgroundTaskIdentifier]()
    var masterTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    override init() {
        super.init()
    }
    
    func beginNewBackgroundTask() -> UIBackgroundTaskIdentifier {
        DDLogInfo("开始后台任务")
        var bgTaskId = UIBackgroundTaskIdentifier.invalid
        bgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            /// 移除过期任务ID
            DDLogInfo("过期任务ID：\(bgTaskId)")
            self?.bgTaskIdList.removeAll(where: {$0 == bgTaskId})
            UIApplication.shared.endBackgroundTask(bgTaskId)
        })
        /// 如果上次记录的后台任务已失效，就记录当前任务
        if masterTaskId == UIBackgroundTaskIdentifier.invalid {
            masterTaskId = bgTaskId;
        } else {
            bgTaskIdList.append(bgTaskId)
            endBackGroundTask()
        }
        
        return bgTaskId
    }
    
    func endBackGroundTask() {
        
        for i in 0..<bgTaskIdList.count-1 {
            let bgTaskId = bgTaskIdList[i]
            UIApplication.shared.endBackgroundTask(bgTaskId)
            bgTaskIdList.removeFirst()
        }
    }
}


