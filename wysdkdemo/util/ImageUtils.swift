//
//  ImageUtils.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/11.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation


class ImageUtils {
    
   
    
    static func getImageHighlighted()->UIImage{
        let color = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 0.1)
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

  
}
