//
//  WYWebView.swift
//  WeprintIOS
//
//  Created by weiyin on 15/11/18.
//  Copyright © 2015年 weiyin. All rights reserved.
//

import Foundation
import UIKit

class WYWebView : UIWebView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        //print(action.description)
        if action.description.contains("copy")  || action.description == "select" {
            return true
        }
        return false
    }
 
}
