//
//  BaseProtocol.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import Bolts

class BaseProtocol : NSObject{
    
    func postRequest(_ url:String, json : [String : AnyObject],nonce:Int,timestamp:Int,signature:String) ->AnyObject?{
        
        let tcs = BFTaskCompletionSource<AnyObject>()
        let head = ["Content-type":"text/json","Nonce":"\(nonce)","Timestamp":"\(timestamp)","Authorization":signature]
        
        request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: head).responseJSON { (response) in
                if(response.result.isFailure){
                    tcs.setError(response.result.error!)

                    print("")
                    print("postRequest Error --" + url)
                    print(response.response)
                    print(response.result.error)
                    print("")
                }else{
                    let result = response.result.value as AnyObject?
                    tcs.setResult(result)

                    print("")
                    print("postRequest " + "\(Converter<BaseResultBean>.conver(result)?.resultCode)" + " --" + url)
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
    
    func sendGetRequest(_ url:String) ->AnyObject?{
        let tcs = BFTaskCompletionSource<AnyObject>()
        
        request(url, method: .get).responseJSON { (response) in
            if(response.result.isFailure){
                tcs.setError(response.result.error!)
                
                print("")
                print("sendGetRequest error url -- " + url)
                tcs.setError(response.result.error!)
            }else{
                let result = response.result.value as AnyObject?
                tcs.setResult(result)
            }
        }
                
        if((tcs.task.error) == nil){
            return tcs.task.result
        }else{
            return nil
        }
    }
}
