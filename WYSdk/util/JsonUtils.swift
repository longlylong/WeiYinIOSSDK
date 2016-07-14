//
//  JsonUtils.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/21.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

class JsonUtils {
    
    static func toDic(json:String) -> AnyObject?{
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let dic = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        return dic
    }
    
   static func toJSONString(dict:NSDictionary)->String{
        let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
        return String(strJson!).stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("\\",withString: "")
        
    }
}