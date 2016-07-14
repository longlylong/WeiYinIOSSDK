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
        let date = NSDate()
        let zone = NSTimeZone.systemTimeZone()
        let interval = zone.secondsFromGMTForDate(date)
        return Int(date.timeIntervalSince1970) + interval
    }
    
    static func getCurrentTime()->Int{
        let date = NSDate()
        return Int(date.timeIntervalSince1970)
    }
    
    static func getCurrentTime(format:String) ->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        
        let date = NSDate()
        let str = dateFormatter.stringFromDate(date)
        
        return str
    }
    
    static func getTime(time:Int,format:String) ->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        let str = dateFormatter.stringFromDate(date)
        
        return str
    }
    
    static func getIntTime(date:NSDate)->Int{
        let zone = NSTimeZone.systemTimeZone()
        let interval = zone.secondsFromGMTForDate(date)
        return Int(date.timeIntervalSince1970) + interval
    }
    

}