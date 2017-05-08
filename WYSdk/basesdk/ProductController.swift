//
//  ProductController.swift
//  wysdkdemo
//
//  Created by weiyin on 2017/5/4.
//  Copyright © 2017年 weiyin. All rights reserved.
//

import Foundation
class ProductController: BaseSdk {
    
    fileprivate static let mInstance = ProductController()
    
    fileprivate override init(){}
    
    open static func getInstance() -> ProductController{
        return mInstance
    }
    
    func getProductList(_ start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let resultBean = self.mHttpStore.getProductList(bean: BaseRequestBean())
            self.handleResult(resultBean, controller, resultOk: {
                
                self.callSuccess(controller, t: resultBean!)
                
            }, resultFailed: {
                
            })
        }
    }
    
    func delProduct(_ serial:String, start:UIRequestStart?,success:UIRequestSuccess?,failed:UIRequestFailed?) {
        let controller = Controller(start,success,failed)
        callStart(controller)
        
        runOnAsync {
            let delBean = RequestDelProductBean()
            delBean.serial = serial
            let resultBean = self.mHttpStore.delProduct(bean: delBean)
            self.handleResult(resultBean, controller, resultOk: {
                
                self.callSuccess(controller, t: resultBean!)
                
            }, resultFailed: {
                
            })
        }
    }
}
