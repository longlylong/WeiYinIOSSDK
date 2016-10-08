//
//  OrderController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/16.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
open class OrderController : BaseSdk {
    
    fileprivate let mHttpStore = WYProtocol()
    
    fileprivate static let mInstance = OrderController()
    
    fileprivate override init(){}
    
    open static func getInstance() -> OrderController{
        return mInstance
    }
    
    func getCoupon(_ start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync { 
            let resultBean = self.mHttpStore.getTickets(bean: RequestCouponBean())
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func activateCoupon(_ couponCode:String,start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync { 
            let requestBean = RequestActivateCouponBean()
            requestBean.code = couponCode
            let activatedBean = self.mHttpStore.activateTicket(bean: requestBean)
            self.handleResult(activatedBean, controller, resultOk: {
                
                    self.callSuccess(controller, t: activatedBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    /**
     * @param paymentPattern ZhifubaoApp = 1, WeixinApp = 2
     */
    func payOrder(_ orderSerial:String,paymentPattern:Int,start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean =  RequestPayBean()
            requestBean.orderSerial = orderSerial
            requestBean.paymentPattern = paymentPattern
            let resultBean = self.mHttpStore.payOrder(bean: requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func createOrder(_ receiver:String,mobile:String, buyerMobile:String,paymentPattern:Int,buyerMark:String,province:String,city:String, area:String,address:String,  logistics:Int,ticket:String,shopCartListBean:ShopCartListBean, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        
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
            let resultBean = self.mHttpStore.createOrder(bean: requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func addShopCart(_ bookId:Int,count:Int, workmanship:Int,start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean =  RequestAddShopCartBean()
            requestBean.bookid = bookId
            requestBean.count = count
            requestBean.bookMakeType = workmanship
            
            let resultBean = self.mHttpStore.addShopCart(bean: requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
            
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }

    func delShopCart(_ cartId:Int, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean =  RequestDelShopCartBean()
            requestBean.carId = cartId
            let resultBean = self.mHttpStore.delShopCart(bean: requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
 
            })
        }
    }
    
    func delOrder(_ orderSerial:String, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let requestBean = RequestDelOrderBean()
            requestBean.orderSerial = orderSerial
            let resultBean = self.mHttpStore.delOrder(bean: requestBean)
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.handleResult(resultBean, controller, resultOk: { 
                        
                            self.callSuccess(controller, t: resultBean!)
                        
                        }, resultFailed: { 
                            
                    })
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func getOrderList(_ start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            
            let resultBean = self.mHttpStore.getOrders(bean: RequestOrderListBean())
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
    
    func getShopCartList(_ start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let resultBean = self.mHttpStore.getShopCart(bean: RequestShopCartListBean())
            self.handleResult(resultBean, controller, resultOk: { 
                
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: { 
                    
            })
        }
    }
}
