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

    static let BOBY_FONT_SIZE:CGFloat = 14
    
    static func getScreenWidth()->CGFloat{
        return  UIScreen.main.bounds.width
    }
    
    static func getScreenHeight()->CGFloat{
        return  UIScreen.main.bounds.height
    }
    
    static func getTipsGray()->UIColor{
        return colorWithHexString("#10565656")
    }
    
    static func getThemeColor()->UIColor{
        return colorWithHexString("#f56971")
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
    
    class func getLineBackgroundColor()->UIColor{
        return colorWithHexString("#F3F3F3")
    }
    
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
    
    static func initLabel(_ frame:CGRect,fontSize:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment)->UILabel {
        let label = UILabel()
        label.frame = frame
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.textAlignment = textAlignment
        return label
    }
    
    static func startUploadAnimation(_ topImg:UIImageView!){
        if topImg == nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = TimeInterval(1.5)
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        topImg.layer.add(animation, forKey: nil)
    }
    
    static func clearUploadAnimation(_ topImg:UIImageView!){
        if topImg == nil {
            return
        }
        topImg.layer.removeAllAnimations()
    }
    
    /*!
     * 从16进制颜色值获取UIColor
     */
    fileprivate static func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
