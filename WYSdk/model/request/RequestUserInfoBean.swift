//
//  RequestUserInfoBean.swift
//  WYSdk
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

class RequestUserInfoBean : BaseRequestBean{
    
    var openId = ""
    
    var name = ""
    
    var headImg = ""
    
    override func toJson() -> [String : AnyObject] {
        return[
            "openId" : openId as AnyObject ,
            "name" : name as AnyObject ,
            "headImg" : headImg as AnyObject

        ]
    }
}
