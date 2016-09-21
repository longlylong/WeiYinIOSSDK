//
//  BaseResultBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON
//import SwiftyJSON

class BaseResultBean : HandyJSON{
    
    required init() {
        
    }
    
    var resultCode = ""
    
    var errorMsg = ""
    
    func ok()->Bool{
        return HttpConstant.SUCCESS == self.resultCode
    }
}
