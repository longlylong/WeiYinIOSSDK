//
//  CouponActivatedBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

class CouponActivatedBean :BaseResultBean{
    
    var ticket  = CouponBean.Ticket()
    
    static func toCouponActivatedBean(jsonData:AnyObject?) -> CouponActivatedBean {
        let json  = JSON(jsonData!)
        let bean = CouponActivatedBean()
        bean.errorMsg = json["errorMsg"].stringValue
        bean.resultCode = json["resultCode"].stringValue
        
        bean.ticket  = CouponBean.getTicket(subJson: json)
        
        return bean
    }
}
