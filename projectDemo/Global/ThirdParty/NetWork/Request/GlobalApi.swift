//
//  GlobalApi.swift
//  projectDemo
//
//  Created by Cheng on 2022/5/30.
//

import Foundation
import Moya

let globalProvider = MoyaProvider<GlobalApi>(plugins: [GlobalPlugin()])

enum GlobalApi {
    case baseConfig
}

extension GlobalApi: TargetType {
    var baseURL: URL {
        return URL.init(string: "https://www.baidu.com")!
    }
    
    var path: String {
        return "/data"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        // 公共参数
        var params: [String: Any] = ["token": "Gz1qYLXeBW8MZuUfDlr9wsAYuVS1cZFMJY9BbaF842L2gRps747o4w=="]
        
        // 收集参数
        switch self {
        case .baseConfig:
            params["id"] = "1213"
        }
        
        // 发起请求
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    /// 请求头
    var headers: [String : String]? {
        return ["devtype": "iOS"]
    }
    
    
}
