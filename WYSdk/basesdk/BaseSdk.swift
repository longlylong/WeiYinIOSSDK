//
//  BaseController.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation

public class BaseSdk : NSObject{
    
    func callStart(controller: Controller){
        let listener = controller.getStart()
        if  listener != nil{
            runOnMain({ () -> Void in
                listener!()
            })
        }
    }
    
    func callSuccess(controller:Controller,t:AnyObject){
        let listener = controller.getSuccess()
        if  listener != nil{
            runOnMain({ () -> Void in
                listener!(t)
            })
        }
    }
    
    func callFailed(controller:Controller,errorMsg:String){
        let listener = controller.getFailed()
        if  listener != nil{
            runOnMain({ () -> Void in
                listener!(errorMsg)
            })
        }
    }
    
    func runOnAsync(block:(() -> Void)){
        ThreadUtils.threadOnAsync(block)
    }
    
    func runOnHttpQueue(block:(() -> Void)){
        ThreadUtils.threadOnHttpQueue(block)
    }
    
    func runOnMain(block:(() -> Void)){
        ThreadUtils.threadOnMain(block)
    }
    
    func handleResult(baseResultBean :BaseResultBean?,_ controller:Controller,resultOk:ResultOk,resultFailed : ResultFailed){
    
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
