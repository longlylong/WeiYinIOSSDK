//
//  ThreadUtils.swift
//  WeprintIOS
//
//  Created by meng on 15/9/8.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

open class ThreadUtils : NSObject{
    
    fileprivate static var Async :DispatchQueue = DispatchQueue(label: "weiyin_async", attributes: DispatchQueue.Attributes.concurrent)
   
    fileprivate static var AsyncHttpQueue :DispatchQueue = DispatchQueue(label: "weiyin_http_queue", attributes: [])
    
    open static func threadOnAfterMain(_ time:UInt64,block:@escaping (() -> Void)){
        ThreadUtils.threadOnAsyncAfter(time,block:  { () -> Void in
            DispatchQueue.main.async(execute: block)
        })
    }
    
    static func threadOnMain(_ block:@escaping (() -> Void)){
        DispatchQueue.main.async(execute: block)
    }
    
    static func threadOnAsync(_ block:@escaping (() -> Void)){
        Async.async(execute: block)
    }

    //毫秒
    static func threadOnAsyncAfter(_ time:UInt64,block:@escaping (() -> Void)){
        Async.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(time * NSEC_PER_MSEC)) / Double(NSEC_PER_SEC), execute: block)
    }
    
    static func threadOnHttpQueue(_ block:@escaping (() -> Void)){
        AsyncHttpQueue.async(execute: block)
    }
    
}
