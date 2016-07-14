//
//  RequestDelShopCartBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
class RequestDelShopCartBean : BaseRequestBean {
    
    
    var carId = 0
    
    override func toJson() -> [String : AnyObject] {
        
        return [
            "identity" : identity ,
            
            "carId" : carId
        ]
    }
}