//
//  UserController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/8/4.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
public class UserController: BaseSdk {

    private var mLastHttpDNSRequestTime = 0
    private let mHttpStore = WYProtocol()
    
    private static let mInstance = UserController()
    
    private override init(){}
    
    public static func getInstance() -> UserController{
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