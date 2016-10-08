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
    
    func getHttpDNSIp(){
        if  TimeUtils.getCurrentTime() - mLastHttpDNSRequestTime < 30 * 60 {
            return
        }
        
        runOnAsync {
            var ip = ""
            let httpDNSBean = self.mHttpStore.getHttpDNSIp()
            if httpDNSBean != nil && !httpDNSBean!.ips.isEmpty{
                ip = httpDNSBean!.ips[0]
                self.mLastHttpDNSRequestTime = TimeUtils.getCurrentTime()
            }
            WYSdk.getInstance().ip = ip
        }
    }
}
