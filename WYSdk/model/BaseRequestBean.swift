//
//  BaseRequestBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/28.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON

public class BaseRequestBean : NSObject, HandyJSON{
    

    var identity = ""
    
    required override public init(){
        
    }
    
    func toJson() -> [String : Any] {
        identity = WYSdk.getInstance().getIdentity()
        return self.toJSON()!
    }
}
