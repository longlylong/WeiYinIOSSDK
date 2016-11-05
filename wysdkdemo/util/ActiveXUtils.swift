//
//  ActiveXUtils.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 16/3/7.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

class ActiveXUtils {
    
    static func initLabel(_ frame:CGRect,fontSize:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment)->UILabel {
        let label = UILabel()
        label.frame = frame
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        return label
    }
    
    static func initButtonWithImage(_ frame:CGRect,imageName:String,target:AnyObject,action:Selector,events:UIControlEvents)->UIButton{
        let button = UIButton(frame: frame)
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.addTarget(target, action: action, for: events)
        button.setBackgroundImage(ImageUtils.getImageHighlighted(), for: UIControlState.highlighted)
        return button
    }
    

}
