//
//  UIUitls.swift
//  WeprintIOS
//
//  Created by weiyin on 15/9/1.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import Foundation
import UIKit

/*!
*  UI工具类
*/
class UIUtils {

    static let BOBY_FONT_SIZE:CGFloat = 13
    
    static func getScreenWidth()->CGFloat{
        return  UIScreen.mainScreen().bounds.width
    }
    
    static func getScreenHeight()->CGFloat{
        return  UIScreen.mainScreen().bounds.height
    }
    
    static func getGrayColor()->UIColor{
        return colorWithHexString("#20565656")
    }
    
    static func getTextBlackColor()->UIColor{
        return colorWithHexString("#0F0F0F")
    }
    
    static func getTextWhiteColor()->UIColor{
        return colorWithHexString("#FFFFFF")
    }
    
    static func getImageHighlighted()->UIImage{
        let color = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 0.1)
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func initLabel(frame:CGRect,fontSize:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment)->UILabel {
        let label = UILabel()
        label.frame = frame
        label.font = UIFont.systemFontOfSize(fontSize)
        label.textColor = textColor
        label.textAlignment = textAlignment
        return label
    }
    
    static func startUploadAnimation(topImg:UIImageView!){
        if topImg == nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = NSTimeInterval(1.5)
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float(CGFloat.max)
        topImg.layer.addAnimation(animation, forKey: nil)
    }
    
    static func clearUploadAnimation(topImg:UIImageView!){
        if topImg == nil {
            return
        }
        topImg.layer.removeAllAnimations()
    }
    
    /*!
     * 从16进制颜色值获取UIColor
     */
    private static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}