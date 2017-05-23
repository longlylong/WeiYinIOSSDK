//
//  UserProtocol.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON
//import SwiftyJSON
//import CryptoSwift

class Converter<T:HandyJSON>{
    static func conver(_ jsonDic:AnyObject?) -> T? {
        if jsonDic == nil {
            return nil
        }
        return JSONDeserializer<T>.deserializeFrom(dict: jsonDic as? NSDictionary)
    }
    
}

class WYProtocol : BaseProtocol{
    
    private let UserInfoUrl = HttpConstant.RootApiUrl + "User/Info"
    private let StructDataUrl = HttpConstant.RootApiUrl + "Data/StructData"
    private let ActivateTicketUrl = HttpConstant.RootApiUrl + "Order/ActivateTicket"
    private let GetTicketsTicketUrl = HttpConstant.RootApiUrl + "Order/GetTickets"
    private let DeleteOrderTicketUrl = HttpConstant.RootApiUrl + "Order/DeleteOrder"
    private let PayOrderUrl = HttpConstant.RootApiUrl + "Order/PayOrder"
    private let GetOrdersUrl = HttpConstant.RootApiUrl + "Order/GetOrders"
    private let CreateOrderUrl = HttpConstant.RootApiUrl + "Order/CreateOrder"
    private let GetShoppingCarUrl = HttpConstant.RootApiUrl + "Order/GetShoppingCar"
    private let AddShoppingCarUrl = HttpConstant.RootApiUrl + "Order/AddShoppingCar"
    private let DeleteShoppingCarUrl = HttpConstant.RootApiUrl + "Order/DeleteShoppingCar"
    
    private let GetProductListUrl = HttpConstant.RootApiUrl + "Book/GetProducts"
    private let DeleteProductUrl = HttpConstant.RootApiUrl + "Book/DeleteProduct"
    
    private func getRandom()->Int{
        let num = arc4random_uniform(899999)
        return Int(num) + 100000
    }
    
    private func getTimestamp()->Int{
        return TimeUtils.getCurrentTime()
    }
    
    private func getSignature(_ nonce:Int,timestamp:Int,url:String)->String{
        let data = "POST" + "\n" + "\(nonce)" + "\n" + "\(timestamp)" + "\n" + url
        
        let sign = data.signature(WYSdk.getInstance().getAccessSecret())
        
        return WYSdk.getInstance().getAccessKey() + ":" + sign
    }
    
    /**
     * 删除作品
     */
    func delProduct(bean:RequestDelProductBean)->BaseResultBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Book/DeleteProduct")
        
        let data: AnyObject? = postRequest(DeleteProductUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<BaseResultBean>.conver(data)
        
        return bean
        
    }
    
    /**
     * 获取我的作品
     */
    func getProductList(bean:BaseRequestBean)->ProductListBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Book/GetProducts")
        
        let data: AnyObject? = postRequest(GetProductListUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<ProductListBean>.conver(data)
        
        return bean
        
    }
    
    /**
     * 激活微印券
     */
    func activateTicket(bean:RequestActivateCouponBean)->CouponActivatedBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/ActivateTicket")
        
        let data: AnyObject? = postRequest(ActivateTicketUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<CouponActivatedBean>.conver(data)
        
        return bean
        
    }
    
    /**
     * 获取微印券
     */
    func getTickets(bean:RequestCouponBean)->CouponBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/GetTickets")
        
        let data: AnyObject? = postRequest(GetTicketsTicketUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<CouponBean>.conver(data)
        
        return bean
    }
    
    /**
     * 删除订单
     */
    func delOrder(bean:RequestDelOrderBean)->BaseResultBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/DeleteOrder")
        
        let data: AnyObject? = postRequest(DeleteOrderTicketUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<BaseResultBean>.conver(data)
        
        return bean
    }
    
    /**
     * 支付订单 并返回支付
     */
    func payOrder(bean:RequestPayBean)->PayBean?{
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/PayOrder")
        
        let data: AnyObject? = postRequest(PayOrderUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<PayBean>.conver(data)
        
        return bean
    }
    
    /**
     * 获取订单列表
     */
    func getOrders(bean:RequestOrderListBean) -> OrderListBean?{
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/GetOrders")
        
        let data: AnyObject? = postRequest(GetOrdersUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<OrderListBean>.conver(data)
        
        return bean
    }
    
    /**
     * 创建订单 并返回支付
     */
    func createOrder(bean:RequestCreateOrderBean)->PayBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/CreateOrder")
        
        let data: AnyObject? = postRequest(CreateOrderUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<PayBean>.conver(data)
        
        return bean
    }
    
    
    /**
     * 获取购物车列表
     */
    func getShopCart(bean:RequestShopCartListBean) -> ShopCartListBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/GetShoppingCar")
        
        let data: AnyObject? = postRequest(GetShoppingCarUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<ShopCartListBean>.conver(data)
        
        return bean
    }
    
    /**
     * 增加增加购物车列表
     */
    func addShopCart(bean:RequestAddShopCartBean)->BaseResultBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/AddShoppingCar")
        
        let data: AnyObject? = postRequest(AddShoppingCarUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<BaseResultBean>.conver(data)
        
        return bean
    }
    /**
     * 增加删除
     */
    func delShopCart(bean:RequestDelShopCartBean)->BaseResultBean? {
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Order/DeleteShoppingCar")
        
        let data: AnyObject? = postRequest(DeleteShoppingCarUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<BaseResultBean>.conver(data)
        
        return bean
    }
    
    func getUserInfo(bean: RequestUserInfoBean) ->UserInfoBean?{
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "User/Info")
        
        let data: AnyObject? = postRequest(UserInfoUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<UserInfoBean>.conver(data)
        
        return bean
    }
    
    /**
     * 提交数据
     */
    func postStructData(bean:RequestStructDataBean) -> PrintBean? {
        
        if AlbumHelper.hasOnePBlock(bean.structData.dataBlocks){
            bean.structData.flyleaf = nil
            bean.structData.preface = nil
            bean.structData.copyright = nil
            
            var photoArr = Array<Block>()
            for b in bean.structData.dataBlocks{
                if b.blockType != RequestStructDataBean.TYPE_CHAPTER {
                    photoArr.append(b)
                }
            }
            bean.structData.dataBlocks = photoArr
        }
        
        let json = bean.toJson()
        
        let num = getRandom()
        let timestamp = getTimestamp()
        
        let sign = getSignature( num, timestamp: timestamp, url: "Data/StructData")
        
        let data: AnyObject? = postRequest(StructDataUrl, json: json, nonce: num,timestamp: timestamp,signature: sign)
        
        let bean = Converter<PrintBean>.conver(data)
        
        return bean
    }
    
}
