//
//  GlobalPlugin.swift
//  projectDemo
//
//  Created by Cheng on 2022/5/30.
//

import Foundation
import Moya

/// 网络插件

/// 通用网络插件
class GlobalPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("Request: \(String(describing: target.baseURL.absoluteString + target.path)) did Receive result \(result)")
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {

        // 在这里对请求进行统一处理（比如有加密，可以统一进行解密）

        return result
    }
}
