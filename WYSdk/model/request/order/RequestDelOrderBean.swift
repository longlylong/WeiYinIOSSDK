//
//  RequestDelOrderBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

class RequestDelOrderBean : BaseRequestBean {
    
    var orderSerial = ""
    
    override func toJson() -> [String : AnyObject] {
        
        return [
            "identity" : identity as AnyObject ,
            
            "orderSerial" : orderSerial as AnyObject
        ]
    }
    
}
