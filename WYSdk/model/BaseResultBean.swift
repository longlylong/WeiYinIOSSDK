//
//  BaseResultBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

class BaseResultBean : AnyObject{
    
    
    var resultCode = ""
    
    var errorMsg = ""
    
    func ok()->Bool{
        return HttpConstant.SUCCESS == self.resultCode
    }
    
     static func toBaseResultBean(jsonData:AnyObject?) -> BaseResultBean {
        let json  = JSON(jsonData!)
        let bean = BaseResultBean()
        bean.resultCode = json["resultCode"].stringValue
        bean.errorMsg = json["errorMsg"].stringValue

        return bean
    }
    
}