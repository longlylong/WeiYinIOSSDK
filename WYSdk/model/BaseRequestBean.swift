//
//  BaseRequestBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/28.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

class BaseRequestBean : AnyObject{
    

    var identity = ""
    
    init(){
        identity = WYSdk.getInstance().getIdentity()
    }
    
    func toJson() -> [String : AnyObject] {
        
        return [
            "identity" : identity as AnyObject
        ]
    }
}
