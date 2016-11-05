//
//  AnimUtils.swift
//  WeprintIOS
//
//  Created by weiyin on 15/12/17.
//  Copyright © 2015年 weiyin. All rights reserved.
//

import Foundation

class AnimUtils {
    
    static func startUploadAnimation(_ topImg:UIImageView!){
        if topImg == nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
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

    static func moveViewAnimation(_ view:UIView,optName:String,hidden:Bool,distance:Any,durationTime:Float){
        view.isHidden = hidden
        let animation = CABasicAnimation(keyPath:optName)
        animation.fromValue = 0
        animation.toValue = distance
        animation.duration = TimeInterval(durationTime)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float(1)
        view.layer.add(animation, forKey: nil)
    }
}
