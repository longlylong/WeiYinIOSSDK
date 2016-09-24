//
//  String+king.swift
//  wysdkdemo
//
//  Created by weiyin on 16/4/15.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
import CryptoSwift

extension String{
    
    public func signature(_ key:String)->String{
        //let keyBytes = (key.data(using: String.Encoding.utf8)?.arrayOfBytes())!
        let authenticator = try! HMAC(key: key, variant: HMAC.Variant.sha1)
        return  try! self.utf8.lazy.map({ $0 as UInt8 }).authenticate(with: authenticator).toBase64()!
    }
}
