//
//  OrderController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/16.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
public class OrderController : BaseSdk {
    
    private let mHttpStore = WYProtocol()
    
    private static let mInstance = OrderController()
    
    private override init(){}
    
    public static func getInstance() -> OrderController{
        return mInstance
    }
    
    func getCoupon(start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync { 
            let resultBean = self.mHttpStore.getTickets(RequestCouponBean())
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func activateCoupon(couponCode:String,start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync { 
            let requestBean = RequestActivateCouponBean()
            requestBean.code = couponCode
            let activatedBean = self.mHttpStore.activateTicket(requestBean)
            self.handleResult(activatedBean, controller, resultOk: {
                
                    self.callSuccess(controller, t: activatedBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    /**
     * @param paymentPattern ZhifubaoApp = 1, WeixinApp = 2
     */
    func payOrder(orderSerial:String,paymentPattern:Int,start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean =  RequestPayBean()
            requestBean.orderSerial = orderSerial
            requestBean.paymentPattern = paymentPattern
            let resultBean = self.mHttpStore.payOrder(requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func createOrder(receiver:String,mobile:String, buyerMobile:String,paymentPattern:Int,buyerMark:String,province:String,city:String, area:String,address:String,  logistics:Int,ticket:String,shopCartListBean:ShopCartListBean, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean = RequestCreateOrderBean()
            requestBean.cars = shopCartListBean.cars
            requestBean.receiver = receiver
            requestBean.mobile = mobile
            requestBean.buyerMobile = buyerMobile
            requestBean.paymentPattern = paymentPattern
            requestBean.buyerMark = buyerMark
            requestBean.province = province
            requestBean.city = city
            requestBean.area = area
            requestBean.address = address
            requestBean.logistics = logistics
            requestBean.ticket = ticket
            let resultBean = self.mHttpStore.createOrder(requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func addShopCart(bookId:Int,count:Int, workmanship:Int,start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean =  RequestAddShopCartBean()
            requestBean.bookid = bookId
            requestBean.count = count
            requestBean.bookMakeType = workmanship
            
            let resultBean = self.mHttpStore.addShopCart(requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
            
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }

    func delShopCart(cartId:Int, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean =  RequestDelShopCartBean()
            requestBean.carId = cartId
            let resultBean = self.mHttpStore.delShopCart(requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
 
            })
        }
    }
    
    func delOrder(orderSerial:String, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean = RequestDelOrderBean()
            requestBean.orderSerial = orderSerial
            let resultBean = self.mHttpStore.delOrder(requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.handleResult(resultBean, controller, resultOk: { 
                        
                            self.callSuccess(controller, t: resultBean!)
                        
                        }, resultFailed: { 
                            
                    })
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func getOrderList(start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            
            let resultBean = self.mHttpStore.getOrders(RequestOrderListBean())
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func getShopCartList(start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let resultBean = self.mHttpStore.getShopCart(RequestShopCartListBean())
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
}