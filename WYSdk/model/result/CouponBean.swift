//
//  CouponBean.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/14.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON
//import SwiftyJSON

class CouponBean :BaseResultBean{
    
    var ticket  = Array<Ticket>()
    
    func toJson() -> [String:Any] {

        return self.toJSON()!
    }
    
    class Ticket : HandyJSON{
        
        required init() {
            
        }
        
        func toJson() -> [String:Any] {
           return self.toJSON()!
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
