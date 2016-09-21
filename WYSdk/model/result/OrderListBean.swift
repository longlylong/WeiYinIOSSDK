//
//  OrderListBean.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/11.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON
//import SwiftyJSON

/**
* 订单列表
* Created by King on 2015/7/2 0002.
*/
class OrderListBean : BaseResultBean {
    
    static var WaitingToPay = 0
    static var Paid = 1
    static var InProduction = 2
    static var Delivered = 3;
    static var GenerateComplete = 4
    static var PrintingComplete = 5
    static var Complete = 6
    static var Received = 7
    static var Transaction = 9
    static var OrderClosing = 100
    
    var orders = Array<Order>()
    
    class Order : HandyJSON{
        
        required init() {
        }
        
        var orderSerial = ""//
        
        var address = ""//
        
        var receiver = ""//
        
        var mobile = ""//
        
        var buyerMobile = ""//
        
        var paymentPattern = 0 //0,
        
        /**
        * orderstatus:等待付款 = 0,
        * 已付款 = 1, //用户不可见
        * 正在制作 = 2,
        * 已发货 = 3,
        * 生成完成 = 4,
        * 印刷完成 = 5,
        * 装订完成 = 6,
        * 已收件 = 7,
        * 交易完成 = 9,
        * 订单关闭 = 100
        */
        var orderStatus = 0//0,
        
        var totalPrice : Float = 0.0//0.0,
        
        var quantity  = 0//0,
        
        var buyerMark = ""//
        
        var trackingNumber = ""//
        
        var createTime = 0//"0001-01-01T00:00:00",
        
        var payTime = 0
        
        var deliveryTime = 0
        
        var generateTime = 0
        
        var closeTime = 0
        
        var province = ""
        
        var city = ""
        
        var area = ""
        
        var logistics = 0//0,
        
        var kuaiDiUrl = ""
        
        var discount :Float = 0.0//0.0,
        
        var fee :Float = 0.0//0.0,
        
        var displayType = 0 //0默认订单 1历史订单
        
        var desc = ""//等待付款和正在制作的描述
        
        var details = Array<Detail>()
        
        func toJson() -> [String:AnyObject] {
            var detailArr = Array<[String : AnyObject]>()
            for d in details{
                detailArr.append(d.toJson())
            }
            
            return[
                "orderSerial":orderSerial,
                "address":address,
                "receiver":receiver,
                "mobile":mobile,
                "buyerMobile":buyerMobile,
                "paymentPattern":paymentPattern,
                "orderStatus":orderStatus,
                "totalPrice":totalPrice,
                "quantity":quantity,
                "buyerMark":buyerMark,
                "trackingNumber":trackingNumber,
                "createTime":createTime,
                "payTime":payTime,
                "deliveryTime":deliveryTime,
                "generateTime":generateTime,
                "closeTime":closeTime,
                "province":province,
                "city":city,
                "area":area,
                "logistics":logistics,
                "kuaiDiUrl":kuaiDiUrl,
                "discount":discount,
                "fee":fee,
                "displayType":displayType,
                "desc":desc,
                "details":detailArr
            ]
        }
    }
    
    class Detail : HandyJSON{
        
        required init() {
        }
        
        var bookId = 0//6,
        
        var bookName = ""//jingtianlei的画册",
        
        var bookType = 0
        
        var serial = ""//W6",
        
        var page = 0//16,
        
        var count = 0//1,
        
        var volume = 0 //--一本有多少册
        
        var price :Float = 0.0//0.01--价格
        
        var frontImage = ""
        
        var bookMakeType = 0
        
        func toJson() -> [String:AnyObject] {
            return[
                "bookId":bookId,
                "bookName":bookName,
                "bookType":bookType,
                "serial":serial,
                "page":page,
                "count":count,
                "volume":volume,
                "price":price,
                "frontImage":frontImage,
                "bookMakeType":bookMakeType
            ]
        }
    }
    
    func toJson() -> [String:AnyObject] {
        
        var orderArr = Array<[String : AnyObject]>()
        for o in orders{
            orderArr.append(o.toJson())
        }
        
        return[
            "orders":orderArr
        ]
    }
}
