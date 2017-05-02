//
//  AlbumHelper.swift
//  wysdkdemo
//
//  Created by weiyin on 2017/5/2.
//  Copyright © 2017年 weiyin. All rights reserved.
//

import Foundation
class AlbumHelper {

    static func checkPhotoCount( photoCount:Int, bookType:Int) ->Bool {
    
        let c = photoCount + 2//加封面封底

        if (bookType == WYSdk.Print_Book
            || bookType == WYSdk.Print_Card) {

            if (c >= 20 && c <= 999) {
                return false
            }

        } else if (bookType == WYSdk.Print_Photo) {

            if (c >= 16 && c <= 999) {
                return false
            }

        } else if (bookType == WYSdk.Print_Calendar) {

            //没封底-1
            if (c - 1 >= 13 && c - 1 <= 25) {
                return false
            }

        } else if (bookType == WYSdk.Print_J_A5) {

            if (c >= 26 && c <= 82) {
                return false
            }

        } else if (bookType == WYSdk.Print_D_A5) {

            if (c >= 24 && c <= 62) {
                return false
            }


        } else if (bookType == WYSdk.Print_D_YL
            || bookType == WYSdk.Print_D_YL_M
            || bookType == WYSdk.Print_D_YL_B
            || bookType == WYSdk.Print_D_YL_M_B) {

            if (c >= 30 && c <= 86) {
                return false
            }
        }

        return true
    }
    
    static func photoRange(bookType:Int) ->[Int] {
    
        var range = [20,999]
        if (bookType == WYSdk.Print_Book
            || bookType == WYSdk.Print_Card) {
        
            range[0] = 20
            range[1] = 999
        
        } else if (bookType == WYSdk.Print_Photo) {
        
            range[0] = 16
            range[1] = 999
        
        } else if (bookType == WYSdk.Print_Calendar) {
        
            range[0] = 13
            range[1] = 25
        
        } else if (bookType == WYSdk.Print_J_A5) {
        
            range[0] = 26
            range[1] = 82
        
        } else if (bookType == WYSdk.Print_D_A5) {
        
            range[0] = 24
            range[1] = 82
        
        
        } else if (bookType == WYSdk.Print_D_YL
            || bookType == WYSdk.Print_D_YL_M
            || bookType == WYSdk.Print_D_YL_B
            || bookType == WYSdk.Print_D_YL_M_B) {
        
            range[0] = 30
            range[1] = 86
        }
        
        return range
    }
}
