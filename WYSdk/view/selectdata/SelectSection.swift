//
//  SelectSection.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

class SelectSection: UICollectionReusableView {
    
    static func getReuseIdentifier() -> String{
        return "SelectSection"
    }
    
    var mSectionHeaderView = UIView()
    var mChapterNameLabel = UILabel()
    var mAllSelectBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSectionHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initSectionHeaderView(){
        mSectionHeaderView.removeFromSuperview()
        mSectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIUtils.getScreenWidth(), height: 40))
        
        mChapterNameLabel = UILabel(frame: CGRect(x: 12, y: 10,width: UIUtils.getScreenWidth() - 40, height: 20))
        mChapterNameLabel.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        mChapterNameLabel.textColor = UIUtils.getTextBlackColor()
        mChapterNameLabel.textAlignment = NSTextAlignment.left
        mSectionHeaderView.addSubview(mChapterNameLabel)
        
        mAllSelectBtn = UIButton(frame: CGRect(x: UIUtils.getScreenWidth() - 52, y: 2, width: 40, height: 40))
        mAllSelectBtn.setTitle("全选", for: UIControlState())
        mAllSelectBtn.setTitleColor(UIUtils.getTextBlackColor(), for: UIControlState())
        mAllSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mAllSelectBtn.setBackgroundImage(UIUtils.getImageHighlighted(), for: UIControlState.highlighted)
        mAllSelectBtn.titleLabel?.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        mSectionHeaderView.addSubview(mAllSelectBtn)
        self.addSubview(mSectionHeaderView)
    }
    
    func setHeaderData(_ group: Block,indexPath:IndexPath){
        mChapterNameLabel.text = group.chapter.title
        mAllSelectBtn.tag = (indexPath as NSIndexPath).section
        
        if group.isSelected {
            mAllSelectBtn.setTitle("取消", for: UIControlState())
        }else{
            mAllSelectBtn.setTitle("全选", for: UIControlState())
        }
    }
}
