//
//  JsonUtils.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/21.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

class JsonUtils {
    
    static func toDic(_ json:String) -> AnyObject?{
        let data = json.data(using: String.Encoding.utf8)
        let dic = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
        return dic as AnyObject?
    }
    
   static func toJSONString(_ dict:NSDictionary)->String{
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return String(strJson!).replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\",with: "")
        
    }
}
