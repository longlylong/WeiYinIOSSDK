//
//  ShopCartListBean.swift
//  WeprintIOS
//
//  Created by meng on 15/9/11.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyJSON

/**
* 购物车的类
* Created by King on 2015/7/2 0002.
*/
class ShopCartListBean : BaseResultBean  {
    
    var cars = Array<Cart>()
    
    class Cart{
        
        var bookId = 0
        var count = 0
        var carId = 0
        var bookName = ""
        var pricePageCount = 0
        var price :Float = 0.0
        
        var volume = 0
        
        var frontImage = ""
    
        var bookMakeType = 0
        
        static func toCart(json:JSON)->Cart{
            let c = Cart()
            c.bookId = json["bookId"].intValue
            c.count = json["count"].intValue
            c.carId = json["carId"].intValue
            c.bookName = json["bookName"].stringValue
            c.pricePageCount = json["pricePageCount"].intValue
            c.price = json["price"].floatValue
            c.volume = json["volume"].intValue
            c.frontImage = json["frontImage"].stringValue
            c.bookMakeType = json["bookMakeType"].intValue
            return c
        }
        
        func toJson()-> [String : AnyObject]{
            return [
                "bookId" : bookId as AnyObject,
                "count" : count as AnyObject,
                "carId" : carId as AnyObject,
                "bookName" : bookName as AnyObject,
                "pricePageCount" : pricePageCount as AnyObject,
                "price" : price as AnyObject,
                "volume" : volume as AnyObject,
                "frontImage" : frontImage as AnyObject,
                "bookMakeType" : bookMakeType as AnyObject
            ]
        }
    }
    
    func toJson() -> [String:AnyObject] {
        var cartArr = Array<[String : AnyObject]>()
        for o in cars{
            cartArr.append(o.toJson())
        }
        return[
            "cars":cartArr as AnyObject
        ]
    }

    
    static func toShopCartListBean(jsonData:AnyObject?) -> ShopCartListBean {
        let json  = JSON(jsonData!)
        let bean = ShopCartListBean()
        bean.errorMsg = json["errorMsg"].stringValue
        bean.resultCode = json["resultCode"].stringValue
        
        let cartArr = json["cars"]
        
        for(_, subJson): (String, JSON) in cartArr{
            bean.cars.append(Cart.toCart(json: subJson))
        }
        
        return bean
    }
    
}
