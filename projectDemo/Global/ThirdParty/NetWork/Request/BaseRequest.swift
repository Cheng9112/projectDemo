//
//  BaseRequest.swift
//  projectDemo
//
//  Created by Cheng on 2021/5/28.
//

import UIKit

class BaseRequest: YTKRequest {

    typealias requestCompletionBlock = (BaseModel?, BaseRequest?) -> ()
    private var successBlock: requestCompletionBlock!
    private var failureBlock: requestCompletionBlock!
    
    override init() {
        super.init()
    }
// MARK: - 基础数据
    override func baseUrl() -> String {
        return ""
    }
    
    override func requestTimeoutInterval() -> TimeInterval {
        return 10
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return YTKRequestMethod.GET
    }
    
// MARK: - 请求头
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        
        return ["": ""]
    }
}

// MARK: - Public
extension BaseRequest {
    /// 接口请求
    public func loadWithCompletionBlockWithSuccess(success: @escaping requestCompletionBlock, failure: @escaping requestCompletionBlock) {
        
        successBlock = success
        failureBlock = failure
        
        startWithCompletionBlock { [weak self] (baseRequest)  in
            
            if let model = BaseModel.deserialize(from: baseRequest.responseString) {
                self?.successBlock(model, self)
            } else {
                self?.successBlock(nil, self)
            }
            
        } failure: { [weak self] (baseRequest) in
            self?.successBlock(nil, self)
        }

    }
}
