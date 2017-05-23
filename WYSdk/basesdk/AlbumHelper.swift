//
//  AlbumHelper.swift
//  wysdkdemo
//
//  Created by weiyin on 2017/5/2.
//  Copyright © 2017年 weiyin. All rights reserved.
//

import Foundation
class AlbumHelper {

    static func checkPhotoCount( photoCount:Int, bookType:Int, makeType:Int,datas: Array<Block>) ->Bool {
        
        let c = photoCount + 2//加封面封底

        if (bookType == WYSdk.BookType_Big
            || bookType == WYSdk.BookType_Card) {
            
            if (makeType == WYSdk.MakeType_28P
                || makeType == WYSdk.MakeType_28P_B
                || makeType == WYSdk.MakeType_28P_M
                || makeType == WYSdk.MakeType_28P_M_B) {
                
                if hasOnePBlock(datas){
                    let onePCount = onePBlockCount(datas)
                    let maxP = 32 - onePCount
                    if c >= maxP && c <= maxP * 3{
                        return false
                    }
                }else if (c >= 30 && c <= 86) {
                    return false
                }
            } else if (c >= 20 && c <= 999) {
                return false
            }
            
        } else if (bookType == WYSdk.BookType_Photo) {
            
            if (c >= 16 && c <= 999) {
                return false
            }
            
        } else if (bookType == WYSdk.BookType_Calendar) {
            
            //没封底-1
            if (c - 1 >= 13 && c - 1 <= 25) {
                return false
            }
            
        } else if (bookType == WYSdk.BookType_A4) {
            
            if (makeType == WYSdk.MakeType_A4_D) {
                if (c >= 24 && c <= 62) {
                    return false
                }
            } else {
                if (c >= 26 && c <= 82) {
                    return false
                }
            }
        }

        return true
    }
    
    static func photoRange(bookType:Int, makeType:Int, datas:Array<Block>) ->[Int] {
    
        var range = [20,999]
        if (bookType == WYSdk.BookType_Big
            || bookType == WYSdk.BookType_Card) {
            
            if (makeType == WYSdk.MakeType_28P
                || makeType == WYSdk.MakeType_28P_B
                || makeType == WYSdk.MakeType_28P_M
                || makeType == WYSdk.MakeType_28P_M_B) {
                
                if hasOnePBlock(datas){
                    let onePCount = onePBlockCount(datas)
                    let maxP = 32 - onePCount
                    range[0] = maxP
                    range[1] = maxP * 3
                }else{
                    range[0] = 30
                    range[1] = 86
                }
             
            } else {
                range[0] = 20
                range[1] = 999
            }
            
        } else if (bookType == WYSdk.BookType_Photo) {
            
            range[0] = 16
            range[1] = 999
            
        } else if (bookType == WYSdk.BookType_Calendar) {
            
            range[0] = 13
            range[1] = 25
            
        } else if (bookType == WYSdk.BookType_A4) {
            
            if (makeType == WYSdk.MakeType_A4_D) {
                range[0] = 24
                range[1] = 82
            } else {
                range[0] = 26
                range[1] = 82
            }
        }
        return range
    }
    
    static func hasOnePBlock(_ datas:Array<Block>)->Bool{
        for b in datas{
            if b.type == RequestStructDataBean.TYPE_ONE_P{
                return true
            }
        }
        
        return false
    }
    
    static func onePBlockCount(_ datas:Array<Block>)->Int{
        var count = 0
        for b in datas{
            if b.type == RequestStructDataBean.TYPE_ONE_P{
                count = count + 1
            }
        }
        
        return count
    }
}
