//
//  ActivityBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/2.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

class HttpDNSBean {
    
    var ips  = Array<String>()
    
    var host = ""
    
    var ttl = 0
    
    static func toHttpDNSBean(jsonData:AnyObject?) -> HttpDNSBean {
        let bean = HttpDNSBean()
        if jsonData == nil {
            return bean
        }
        
        let json  = JSON(jsonData!)
        
        bean.host = json["host"].stringValue
        bean.ttl = json["ttl"].intValue
        
        let arr  = json["ips"].arrayObject
        
        if arr != nil {
            for ip in arr!{
                bean.ips.append(ip as! String)
            }
        }

        return bean
    }
    
}