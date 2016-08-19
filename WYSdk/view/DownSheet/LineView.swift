//
//  LineView.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 15/10/10.
//  Copyright © 2015年 weiyin. All rights reserved.
//

import UIKit

class LineView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initLine(){
        self.backgroundColor = UIUtils.getLineBackgroundColor()
    }
    
}
