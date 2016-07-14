//
//  String+king.swift
//  wysdkdemo
//
//  Created by weiyin on 16/4/15.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import CryptoSwift

extension String{
    
    public func signature(key:String)->String{
        let keyBytes = (key.dataUsingEncoding(NSUTF8StringEncoding)?.arrayOfBytes())!
        let authenticator = Authenticator.HMACAuth(key: keyBytes, variant: HMAC.Variant.sha1)
        return  try! self.utf8.lazy.map({ $0 as UInt8 }).authenticate(authenticator).toBase64()!
    }
}