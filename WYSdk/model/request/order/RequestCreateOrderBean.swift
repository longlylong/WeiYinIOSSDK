//
//  CreateOrderRequestBean.swift
//  WeprintIOS
//
//  Created by meng on 15/9/10.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

class RequestCreateOrderBean : BaseRequestBean {
    
    var cars = Array<ShopCartListBean.Cart>()
    
    var receiver = ""//收件人
    
    var mobile = ""//收件人电话
    
    var buyerMobile = ""//下单人电话（可空）
    
    /**
    * ZhifubaoApp = 1,
    * WeixinApp = 2
    */
    var paymentPattern = 0//支付渠道
    
    var buyerMark = ""//订单留言
    
    var province = ""//省
    
    var city = ""// 市
    
    var area = ""//区
    
    var address = ""//详细地址
    
    /**
    * 圆通快递 = 1,
    * 韵达快递 = 2,
    * 顺丰快递 = 3,
    * 申通快递 = 4,
    * EMS = 5,
    * 中通快递 = 6,
    * 其它 = 7,
    * 顺风空运 = 8
    */
    var logistics = 0//快递类型
    
    var ticket = ""//微印券
    
}
