//
//  PrintBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/13.
//  Copyright © 2016年 weiyin. All rights reserved.
//
import Foundation
//import SwiftyJSON

class PrintBean : BaseResultBean {
    
    var  url = ""
    
    var unionId = 0
    
    static func toPrintBean(jsonData:AnyObject?) -> PrintBean {
        let json  = JSON(jsonData!)
        let bean = PrintBean()
        bean.resultCode = json["resultCode"].stringValue
        bean.errorMsg = json["errorMsg"].stringValue
        
        bean.url = json["url"].stringValue
        bean.unionId = json["unionId"].intValue
        
        return bean
    }
}