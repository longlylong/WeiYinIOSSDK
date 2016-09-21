//
//  PayBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

/**
 * 在订单面页支付的
 * Created by King on 2015/7/3 0003.
 */
class PayBean : BaseResultBean {
    
    var orderSerial = ""
    
    var randomKey = ""
    
    var price : Float = 0.0
    
    var charge = ""
    
    var isPay = false
}
