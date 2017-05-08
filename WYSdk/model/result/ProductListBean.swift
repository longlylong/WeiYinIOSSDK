//
//  ProductListBean.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 16/11/28.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON

class ProductListBean: BaseResultBean {
    
    
    var products = Array<ProductBean>()
    
    class ProductBean: HandyJSON {
        
        required init() {
            
        }
        var identity = 0
        var bookId = 0 //书的服务器id
        var bookType = 0 //作品的类型
        var frontImage = "" //作品的封面照片路径
        var isForbId = false //是否加入购物车
        var name = ""        //作品名字
        var serial = ""      //进入排版的id
        var unionId = 0      //画册的id
        var updateTime = 0      //更新时间
        var pricePageCount = 0   //作品的页数 大于0表示有作品不是空的
        var productAttribute = Array<ProductAttribute>() //属性集合 参考上方定义
        var typesetCode = ""  //进去排版的参数
        var structUpTime = 0  //画册的更新时间
        
    }
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
    
    class ProductAttribute : HandyJSON {
        required init() {
            
        }
        
        var Key = ""
        var Value = ""

    }
}
