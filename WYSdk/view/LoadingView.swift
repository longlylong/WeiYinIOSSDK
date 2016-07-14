//
//  LoadingView.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/22.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
class LoadingView: UIActivityIndicatorView {

    override init(activityIndicatorStyle style: UIActivityIndicatorViewStyle) {
        super.init(activityIndicatorStyle: style)
        initView()
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        initView()
    }
    required init(coder: NSCoder){
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        self.frame = CGRectMake(UIUtils.getScreenWidth()/2 - 50, UIUtils.getScreenHeight()/2 - 50 , 100, 100)
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.backgroundColor = UIUtils.getGrayColor()
        self.hidesWhenStopped = true
        self.layer.zPosition = 999
    }
    
    func stop()  {
        self.stopAnimating()
    }
    
    func start()  {
        self.startAnimating()
    }
}