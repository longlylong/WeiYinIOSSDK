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

    override func setSelected(_ selected: Bool, animated: Bool) {
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

        mCellView = UIView(frame: CGRect(x: 0, y: 0, width: UIUtils.getScreenWidth(),height: self.frame.size.height))
        mLabelText = UILabel(frame: CGRect(x: 0,y: 0, width: UIUtils.getScreenWidth(),height: self.frame.size.height))
        mLabelText.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        mLabelText.textAlignment = NSTextAlignment.center
        mLabelText.textColor = UIUtils.getTextBlackColor()
        mCellView.addSubview(mLabelText)
        let line = LineView(frame: CGRect(x: 0,y: self.frame.size.height - 1, width: UIUtils.getScreenWidth(), height: 1))
        mCellView.addSubview(line)
        
        self.addSubview(mCellView)
    }
    
    func setData(_ model:WeiYinDownSheetModel){
        mLabelText.text = model.text
        mLabelText.textColor = model.textColor
        
    }
}
