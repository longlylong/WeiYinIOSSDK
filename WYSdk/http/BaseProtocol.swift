//
//  BaseProtocol.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation 
import Alamofire
import Bolts

class BaseProtocol : NSObject{
    
    func postRequest(url:String, json : [String : AnyObject],nonce:Int,timestamp:Int,signature:String) ->AnyObject?{
        
        let tcs = BFTaskCompletionSource()
        let head = ["Content-type":"text/json","Nonce":"\(nonce)","Timestamp":"\(timestamp)","Authorization":signature]
        Alamofire.request(Method.POST, url, parameters: json ,encoding: ParameterEncoding.JSON,headers: head)
            .responseJSON() {  response -> Void in
                
                if(response.result.isFailure){
                    tcs.setError(response.result.error!)
                    
                    print("")
                    print("postRequest Error --" + url)
                    print(response.response)
                    print(response.result.error)
                    print("")
                }else{
                    tcs.setResult(response.result.value)
                    
                    print("")
                    print("postRequest " + "\(BaseResultBean.toBaseResultBean(response.result.value).resultCode)" + " --" + url)
                    print("")
                }
        }
        tcs.task.waitUntilFinished()
        
        if((tcs.task.error) == nil){
            return tcs.task.result
        }else{
            return nil
        }
    }
    
    func sendGetRequest(url:String) ->AnyObject?{
        let tcs = BFTaskCompletionSource()
        
        Alamofire.request(Method.GET, url)
            .responseJSON() { response -> Void in
                
                if(response.result.isFailure){
                    print("")
                    print("sendGetRequest error url -- " + url)
                    tcs.setError(response.result.error!)
                }else{
                    tcs.setResult(response.result.value)
                }
        }
        tcs.task.waitUntilFinished()
        
        if((tcs.task.error) == nil){
            return tcs.task.result
        }else{
            return nil
        }
    }
}
