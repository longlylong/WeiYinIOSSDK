//
//  BaseUIViewController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
class BaseUIViewController : UIViewController {
    
    override func viewDidLoad() {
        initUI()
        initData()
        initListener()
    }
    
    func initUI() {
        
    }
    
    func initData() {
        
    }
    
    func initListener() {
        
    }
    
    func getIconButton(frame:CGRect,iconName:String,action:Selector)->UIButton{
        let button = UIButton(frame: frame)
        button.setImage(UIImage(named:iconName), forState: UIControlState.Normal)
        button.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    func setNavTextButton(){
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(SelectDataViewController.handleLeftButton), forControlEvents: .TouchUpInside)
        backButton.setTitle("关闭", forState: .Normal)
        backButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        let rightButton = UIButton()
        rightButton.addTarget(self, action: #selector(SelectDataViewController.handleRightButton), forControlEvents: .TouchUpInside)
        rightButton.setTitle("确定", forState: .Normal)
        rightButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        rightButton.frame = CGRectMake(0, 0, 40, 40)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        rightButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        let backItem = UIBarButtonItem(customView: backButton)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
}