//
//  ShopCartListBean.swift
//  WeprintIOS
//
//  Created by meng on 15/9/11.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON
//import SwiftyJSON

/**
* 购物车的类
* Created by King on 2015/7/2 0002.
*/
class ShopCartListBean : BaseResultBean  {
    
    var cars = Array<Cart>()
    
    class Cart : HandyJSON{
        
        required init() {
            
        }
        
        var bookId = 0
        var count = 0
        var carId = 0
        var bookName = ""
        var pricePageCount = 0
        var price :Float = 0.0
        
        var volume = 0
        
        var frontImage = ""
    
        var bookMakeType = 0
        var bookType = 0
        func toJson()-> [String : AnyObject]{
            return [
                "bookId" : bookId,
                "count" : count,
                "carId" : carId,
                "bookName" : bookName,
                "pricePageCount" : pricePageCount,
                "price" : price,
                "volume" : volume,
                "frontImage" : frontImage,
                "bookType" : bookType,
                "bookMakeType" : bookMakeType
            ]
        }
    }
    
    func toJson() -> [String:AnyObject] {
        var cartArr = Array<[String : AnyObject]>()
        for o in cars{
            cartArr.append(o.toJson())
        }
        return[
            "cars":cartArr
        ]
    }

    
    static func toShopCartListBean(jsonData:AnyObject?) -> ShopCartListBean {
        var bean = Converter<ShopCartListBean>.conver(jsonData)
        bean = bean == nil ? ShopCartListBean() : bean
        return bean!
    }
    
}
