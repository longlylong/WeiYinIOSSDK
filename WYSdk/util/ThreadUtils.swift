//
//  ThreadUtils.swift
//  WeprintIOS
//
//  Created by meng on 15/9/8.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

public class ThreadUtils : NSObject{
    
    private static var Async :dispatch_queue_t = dispatch_queue_create("weiyin_async", DISPATCH_QUEUE_CONCURRENT)
   
    private static var AsyncHttpQueue :dispatch_queue_t = dispatch_queue_create("weiyin_http_queue", DISPATCH_QUEUE_SERIAL)
    
    public static func threadOnAfterMain(time:UInt64,block:(() -> Void)){
        ThreadUtils.threadOnAsyncAfter(time,block:  { () -> Void in
            dispatch_async(dispatch_get_main_queue(), block)
        })
    }
    
    static func threadOnMain(block:(() -> Void)){
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    static func threadOnAsync(block:(() -> Void)){
        dispatch_async(Async, block)
    }

    //毫秒
    static func threadOnAsyncAfter(time:UInt64,block:(() -> Void)){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * NSEC_PER_MSEC)), Async, block)
    }
    
    static func threadOnHttpQueue(block:(() -> Void)){
        dispatch_async(AsyncHttpQueue, block)
    }
    
}