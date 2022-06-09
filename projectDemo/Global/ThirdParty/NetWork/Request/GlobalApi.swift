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
    case uploadImg(img: UIImage)
    case uploadFileZip(file: Data)
    case downLoadWeb
}

extension GlobalApi: TargetType {
    /// 域名
    public var baseURL: URL {
        return URL.init(string: "https://www.baidu.com")!
    }
    /// 路径
    public var path: String {
        return "/data"
    }
    /// 请求方式
    public var method: Moya.Method {
        switch self {
        case .uploadImg(_):
            return .post
        case .uploadFileZip(_):
            return .post
        default:
            return .get
        }
    }
    /// 请求任务
    public var task: Task {
        // 公共参数
        var params: [String: Any] = ["token": "Gz1qYLXeBW8MZuUfDlr9wsAYuVS1cZFMJY9BbaF842L2gRps747o4w=="]
        // 收集参数
        switch self {
        case .uploadImg(_):
            params["id"] = "1213"
        case .uploadFileZip(_):
            params["id"] = "21"
        default: break
        }
        // 发起请求
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    /// mock数据
    public var sampleData: Data {
        
        switch self {
        case .uploadImg(_):
            return "{\"data\":{\"id\":\"your_new_gif_id\"},\"meta\":{\"status\":200,\"msg\":\"OK\"}}".data(using: String.Encoding.utf8)!
        case .uploadFileZip(_):
            return "{\"data\":{\"id\":\"your_new_gif_id\"},\"meta\":{\"status\":200,\"msg\":\"OK\"}}".data(using: String.Encoding.utf8)!
        default:
            return Data.init()
        }
    }
    /// 请求头
    public var headers: [String : String]? {
        return ["devtype": "iOS"]
    }
    
    
}
