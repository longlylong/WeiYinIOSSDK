//
//  SpUtils.swift
//  wysdkdemo
//
//  Created by weiyin on 16/9/27.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

class SpUtils {
    
    static func getTipsFlag()->Bool{
        if Defaults.hasKey("TipsFlag"){
            return Defaults["TipsFlag"].boolValue
        }
        return true
    }
    
    static func saveTipsFlag(flag:Bool){
        Defaults["TipsFlag"] = flag
    }
    
    static func getOpenId()->String{
        if Defaults.hasKey("OpenId"){
            return Defaults["OpenId"].stringValue
        }
        return ""
    }
    
    static func saveOpenId(openId:String){
        Defaults["OpenId"] = openId
    }
    
    static func createUUID() ->String{
        return String(CFStringCreateCopy(nil, CFUUIDCreateString(nil , CFUUIDCreate(nil))))
    }
}
