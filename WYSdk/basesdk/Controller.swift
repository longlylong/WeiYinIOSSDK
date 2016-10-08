//
//  Controller.swift
//  WeprintIOS
//
//  Created by weiyin on 15/8/27.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
class Controller {
    
    fileprivate var start:UIRequestStart?
    fileprivate var success:UIRequestSuccess?
    fileprivate var failed:UIRequestFailed?
    
    init(_ start :UIRequestStart?,_ success: UIRequestSuccess?,_ failed :UIRequestFailed?){
        self.start = start
        self.success = success
        self.failed = failed
    }
    
    func cancelListener(){
        self.start = nil
        self.success = nil
        self.failed = nil
    }
    
    func getStart() -> UIRequestStart? {
        return self.start
    }
    
    func getSuccess() -> UIRequestSuccess? {
        return self.success
    }
    
    func getFailed() -> UIRequestFailed? {
        return self.failed
    }
    
}
