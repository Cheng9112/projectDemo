//
//  BaseModel.swift
//  projectDemo
//
//  Created by Cheng on 2021/5/28.
//

import UIKit
import HandyJSON

class BaseModel: HandyJSON {
    
    required init() {}
    
    var errorMsg: String?
    var errorCode: Int = 0
    var data: AnyObject?
}
