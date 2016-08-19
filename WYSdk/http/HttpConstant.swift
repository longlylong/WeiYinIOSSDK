//
//  HttpConstant.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

class HttpConstant {
    
    /**
    * 线上服务器
    */
    static var  ONLINE_SERVER = true
            
    private static let  Online_Api_Url = "http://openapi.weiyin.cc/"  //接口
    private static let  Test_Api_Url = "http://apitest.weiyin.cc/"   //接口
    
    static var  RootApiUrl = ONLINE_SERVER ? Online_Api_Url : Test_Api_Url

    /**
     * 请求成功
     */
    static let SUCCESS = "1000"
    
    /**
     * 签名错误
     */
    static let SIGN_ERROR = "1001"
    
    /**
     * 购物车地址
     */
    static func getShowOrderUrl()->String{
        return ONLINE_SERVER ? WYSdk.getInstance().getHost() + "/order/webvieworder" : "http://apptest.weiyin.cc/order/webvieworder"
    }
    
    /**
     * 订单地址
     */
    static func getShowCartUrl()->String{
        return ONLINE_SERVER ? WYSdk.getInstance().getHost() + "/order/webviewcart" : "http://apptest.weiyin.cc/order/webviewcart"
    }
    
    /**
     * 纸质画册地址
     */
    static func getPaperUrl()->String {
        return ONLINE_SERVER ? WYSdk.getInstance().getHost() + "/home/bookshow" : "http://apptest.weiyin.cc/home/bookshow"
    }
}