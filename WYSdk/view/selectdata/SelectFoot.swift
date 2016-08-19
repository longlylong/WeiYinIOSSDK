//
//  SelectSection.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

protocol WeiYinFootDelegate:NSObjectProtocol{
    func onFootClick()
}

class SelectFoot: UICollectionReusableView {
    
    static func getReuseIdentifier() -> String{
        return "SelectFoot"
    }
    
    var mView = UIView()
    var mLoadMoreButton = UIButton()
    var delegate : WeiYinFootDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView(){
        mView.removeFromSuperview()
        
        let screenWidth = UIUtils.getScreenWidth()
        mView = UIView(frame: CGRectMake(0, 0, screenWidth, 48))
        
        mLoadMoreButton = UIButton(frame: CGRectMake(screenWidth/2 - 50, 20,100, 20))
        mLoadMoreButton.setTitle("点击加载更多", forState: UIControlState.Normal)
        mLoadMoreButton.setTitleColor(UIUtils.getGrayColor(), forState: UIControlState.Normal)
        mLoadMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mLoadMoreButton.setBackgroundImage(UIUtils.getImageHighlighted(), forState: UIControlState.Highlighted)
        mLoadMoreButton.titleLabel?.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mLoadMoreButton.addTarget(self, action: #selector(SelectFoot.clickLoadMore), forControlEvents: UIControlEvents.TouchUpInside)
        
        mView.addSubview(mLoadMoreButton)
        
        self.addSubview(mView)
    }
    
    func clickLoadMore()  {
        delegate?.onFootClick()
    }

    func getHeight() -> CGSize {
        return CGSize(width: mView.frame.width, height: mView.frame.height)
    }
  
}