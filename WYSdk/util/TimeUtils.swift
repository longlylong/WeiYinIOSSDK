//
//  TimeUtils.swift
//  WeprintIOS
//
//  Created by meng on 15/9/13.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
class TimeUtils {
    
    static func getCurrentTimeAddTimeZone()->Int{
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return Int(date.timeIntervalSince1970) + interval
    }
    
    static func getCurrentTime()->Int{
        let date = Date()
        return Int(date.timeIntervalSince1970)
    }
    
    static func getCurrentTime(_ format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let date = Date()
        let str = dateFormatter.string(from: date)
        
        return str
    }
    
    static func getTime(_ time:Int,format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let str = dateFormatter.string(from: date)
        
        return str
    }
    
    static func getIntTime(_ date:Date)->Int{
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return Int(date.timeIntervalSince1970) + interval
    }
    

}
