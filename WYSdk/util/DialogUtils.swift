//
//  DialogUtils.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/17.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

class DialogUtils {
    
    //自定义弹窗  传入内容  代理 确定键说明   tag   没有去取消键
    static func showCustomNoCancelDialog(_ delegate:UIAlertViewDelegate?,tag:Int,msg:String,otherBtnTitle:String,title:String){
        dialog(title, msg: msg, delegate: delegate, cancelButtonTitle:nil, otherButtonTitles:otherBtnTitle, tag: tag)
    }
    
    fileprivate static func dialog(_ title:String,msg:String,delegate:UIAlertViewDelegate?,cancelButtonTitle: String?,otherButtonTitles: String,tag:Int){
        
        let alert = UIAlertView(
            title: title,
            message: msg,
            delegate: delegate,
            cancelButtonTitle: cancelButtonTitle,
            otherButtonTitles: otherButtonTitles)
        alert.tag = tag
        alert.show()
    }
}
