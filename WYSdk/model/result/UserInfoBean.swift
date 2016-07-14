//
//  UserInfoBean.swift
//  WYSdk
//
//  Created by weiyin on 16/4/7.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

class UserInfoBean: BaseResultBean {

    var identity = ""
    
    var client = 0
    
    var host = ""
    
    static func toUserInfoBena(jsonData:AnyObject?) -> UserInfoBean {
        let json  = JSON(jsonData!)
        let bean = UserInfoBean()
        bean.resultCode = json["resultCode"].stringValue
        bean.errorMsg = json["errorMsg"].stringValue
        
        bean.identity = json["identity"].stringValue
        bean.client = json["client"].intValue
        bean.host = json["host"].stringValue
        
        return bean
    }
}