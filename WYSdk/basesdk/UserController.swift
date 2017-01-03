//
//  UserController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/8/4.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
open class UserController: BaseSdk {

    fileprivate var mLastHttpDNSRequestTime = 0
    fileprivate let mHttpStore = WYProtocol()
    
    fileprivate static let mInstance = UserController()
    
    fileprivate override init(){}
    
    open static func getInstance() -> UserController{
        return mInstance
    }
    
}
