//
//  AddShopCartRequestBean.swift
//  WeprintIOS
//
//  Created by meng on 15/9/10.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation


class RequestAddShopCartBean : BaseRequestBean {
    
    var bookid = 0
    
    var count = 0
    
    var bookMakeType = 0
    
    override func toJson() -> [String : AnyObject] {
        
        return [
            "identity" : identity ,

            "bookid" : bookid ,
            "count" : count,
            "bookMakeType":bookMakeType
        ]
    }
}