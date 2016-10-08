//
//  OrderConfigBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/10/20.
//  Copyright © 2015年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

/**
* 在订单面页的 48小时发货
* Created by King on 2015/7/3 0003.
*/
class OrderConfigBean : BaseResultBean {
    
    /**
    * 发货时间
    */
    var deliveryTime = ""
    
    /**
    * 购物车 等待付款 文案
    */
    var shoppingCarDesc = "" //"现在支付，预计48小时内（MM月dd日)发货",  //购物车页支付按钮下的提示方案
}
