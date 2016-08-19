//
//  WeiYinDownSheetCell.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 15/9/15.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import UIKit


class WeiYinDownSheetCell: UITableViewCell {
    
    var mCellView = UIView()
    var mLabelText = UILabel()
    
    class func getReuseIdentifier()->String{
        return "WeiYinDownSheetCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func initSheetView(){
        mCellView.removeFromSuperview()

        mCellView = UIView(frame: CGRectMake(0, 0, UIUtils.getScreenWidth(),self.frame.size.height))
        mLabelText = UILabel(frame: CGRectMake(0,0, UIUtils.getScreenWidth(),self.frame.size.height))
        mLabelText.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mLabelText.textAlignment = NSTextAlignment.Center
        mLabelText.textColor = UIUtils.getTextBlackColor()
        mCellView.addSubview(mLabelText)
        let line = LineView(frame: CGRectMake(0,self.frame.size.height - 1, UIUtils.getScreenWidth(), 1))
        mCellView.addSubview(line)
        
        self.addSubview(mCellView)
    }
    
    func setData(model:WeiYinDownSheetModel){
        mLabelText.text = model.text
        mLabelText.textColor = model.textColor
        
    }
}
