//
//  BaseController.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

open class BaseSdk : NSObject{
    
    let mHttpStore = WYProtocol()

    
    func callStart(_ controller: Controller){
        let listener = controller.getStart()
        if  listener != nil{
            runOnMain({ () -> Void in
                listener!()
            })
        }
    }
    
    func callSuccess(_ controller:Controller,t:AnyObject){
        let listener = controller.getSuccess()
        if  listener != nil{
            runOnMain({ () -> Void in
                listener!(t)
            })
        }
    }
    
    func callFailed(_ controller:Controller,errorMsg:String){
        print("errorMsg: " + errorMsg)
        let listener = controller.getFailed()
        if  listener != nil{
            runOnMain({ () -> Void in
                listener!(errorMsg)
            })
        }
    }
    
    func runOnAsync(_ block:@escaping (() -> Void)){
        ThreadUtils.threadOnAsync(block)
    }
    
    func runOnHttpQueue(_ block:@escaping (() -> Void)){
        ThreadUtils.threadOnHttpQueue(block)
    }
    
    func runOnMain(_ block:@escaping (() -> Void)){
        ThreadUtils.threadOnMain(block)
    }
    
    func handleResult(_ baseResultBean :BaseResultBean?,_ controller:Controller,resultOk:ResultOk,resultFailed : ResultFailed){
    
        if(baseResultBean != nil){
            
            if(baseResultBean!.ok()){
                resultOk()
                
            }else{
                resultFailed()
                callFailed(controller, errorMsg: baseResultBean!.resultCode)
                
            }
        }else{
            resultFailed()
            callFailed(controller, errorMsg: "server or network error")
        }
            
    }

}
