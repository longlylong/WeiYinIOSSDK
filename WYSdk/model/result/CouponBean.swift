//
//  CouponBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

class CouponBean :BaseResultBean{
    
    var ticket  = Array<Ticket>()
    
    func toJson() -> [String:AnyObject] {
        var ticketArr = Array<[String : AnyObject]>()
        for o in ticket{
            ticketArr.append(o.toJson())
        }

        return[
            "ticket":ticketArr
        ]
    }
    
    static func toCouponBean(jsonData:AnyObject?) -> CouponBean {
        let json  = JSON(jsonData!)
        let bean = CouponBean()
        bean.errorMsg = json["errorMsg"].stringValue
        bean.resultCode = json["resultCode"].stringValue
        
        let arr  = json["ticket"]
        
        for(_, subJson) : (String, JSON) in arr{
            let ticket = getTicket(subJson)
            bean.ticket.append(ticket)
        }
        
        return bean
    }
    
    static func getTicket(subJson:JSON)->Ticket{
        let ticket = Ticket()
        ticket.code = subJson["code"].stringValue
        ticket.createTime = subJson["createTime"].intValue
        ticket.deadline = subJson["deadline"].intValue
        ticket.isCheck = subJson["isCheck"].boolValue
        ticket.checkTime = subJson["checkTime"].intValue
        ticket.name = subJson["name"].stringValue
        ticket.leastPrice = subJson["mark"].floatValue
        ticket.cutPrice = subJson["deadline"].floatValue
        ticket.discount = subJson["usecounttype"].floatValue
        ticket.useCountType = subJson["leastprice"].intValue
        ticket.mark = subJson["cutprice"].stringValue
        return ticket
    }
    
    class Ticket :AnyObject{
        
        func toJson() -> [String:AnyObject] {
            return[
                "code":code,
                "createTime":createTime,
                "deadline":deadline,
                "isCheck":isCheck,
                "checkTime":checkTime,
                "name":name,
                "leastPrice":leastPrice,
                "cutPrice":cutPrice,
                "discount":discount,
                "useCountType":useCountType,
                "mark":mark
            ]
        }
        
        var code = "" //微印卷号
        var createTime  = 0 //创建时间
        var deadline  = 0 //到期时间
        var isCheck = false //是否使用
        var checkTime  = 0 //使用时间
        var name = "" //名字
        var leastPrice : Float = 0.0 //满多少可减
        var cutPrice : Float = 0.0 //减多少
        var discount :Float = 0.0 //折扣 折扣为0 使用 cutprice
        var useCountType  = 0 //1 一次性的 2多次
        var mark = "" //备注
    }
    
}