//
//  RequestActivateCouponBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
class RequestActivateCouponBean : BaseRequestBean {
    
    var code = ""
    
    override func toJson() -> [String : AnyObject] {
        
        return [
            "identity" : identity as AnyObject ,
            
            "code" : code as AnyObject
        ]
    }
}
