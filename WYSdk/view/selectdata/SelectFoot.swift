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
        mView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 48))
        
        mLoadMoreButton = UIButton(frame: CGRect(x: screenWidth/2 - 50, y: 20,width: 100, height: 20))
        mLoadMoreButton.setTitle("点击加载更多", for: UIControlState())
        mLoadMoreButton.setTitleColor(UIUtils.getGrayColor(), for: UIControlState())
        mLoadMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mLoadMoreButton.setBackgroundImage(UIUtils.getImageHighlighted(), for: UIControlState.highlighted)
        mLoadMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        mLoadMoreButton.addTarget(self, action: #selector(SelectFoot.clickLoadMore), for: UIControlEvents.touchUpInside)
        
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
