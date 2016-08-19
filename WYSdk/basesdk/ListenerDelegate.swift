//
//  Listener.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

//ui层的回调
public typealias UIRequestStart = () ->Void
public typealias UIRequestSuccess = (AnyObject) ->Void
public typealias UIRequestFailed = (String) ->Void

public typealias WYPayOrderBlock = (String,Float,String) ->Void
public typealias WYRefreshOrderBlock = () ->Void
public typealias WYRefreshPayBlock = (String) ->Void
public typealias WYLoadMoreBlock = () ->Void

//控制层使用的回调
typealias ResultOk = () -> Void
typealias ResultFailed = () -> Void