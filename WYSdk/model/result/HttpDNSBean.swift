//
//  ActivityBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/2.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON

class HttpDNSBean : HandyJSON{
    
    required init() {
        
    }
    
    var ips  = Array<String>()
    
    var host = ""
    
    var ttl = 0
}
