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
        mSectionHeaderView = UIView(frame: CGRectMake(0, 0, UIUtils.getScreenWidth(), 40))
        
        mChapterNameLabel = UILabel(frame: CGRectMake(12, 10,UIUtils.getScreenWidth() - 40, 20))
        mChapterNameLabel.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mChapterNameLabel.textColor = UIUtils.getTextBlackColor()
        mChapterNameLabel.textAlignment = NSTextAlignment.Left
        mSectionHeaderView.addSubview(mChapterNameLabel)
        
        mAllSelectBtn = UIButton(frame: CGRectMake(UIUtils.getScreenWidth() - 52, 2, 40, 40))
        mAllSelectBtn.setTitle("全选", forState: UIControlState.Normal)
        mAllSelectBtn.setTitleColor(UIUtils.getTextBlackColor(), forState: UIControlState.Normal)
        mAllSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mAllSelectBtn.setBackgroundImage(UIUtils.getImageHighlighted(), forState: UIControlState.Highlighted)
        mAllSelectBtn.titleLabel?.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mSectionHeaderView.addSubview(mAllSelectBtn)
        self.addSubview(mSectionHeaderView)
    }
    
    func setHeaderData(group:RequestStructDataBean.Block,indexPath:NSIndexPath){
        mChapterNameLabel.text = group.chapter.title
        mAllSelectBtn.tag = indexPath.section
        
        if group.isSelected {
            mAllSelectBtn.setTitle("取消", forState: UIControlState.Normal)
        }else{
            mAllSelectBtn.setTitle("全选", forState: UIControlState.Normal)
        }
    }
}