//
//  WeiYinDownSheet.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 15/9/15.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import UIKit

protocol WeiYinDownSheetDelegate:NSObjectProtocol{
    func onSheetSelectIndex(index:Int)
    func onSheetCancel()
}

class WeiYinDownSheet: UIView,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate{

    var delegate:WeiYinDownSheetDelegate?
    
    var mListTableView:UITableView? = UITableView()
    var mView = UIView()
    var mTitleLabel = UILabel()
    
    var mListData = NSMutableArray()
    var isShowing = false
    var mHeight:CGFloat!
    var mCellHeight = 44
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initWYDownSheet(list:NSMutableArray){
        self.mListData = list

        mCellHeight = 49
      
        mHeight = CGFloat(mCellHeight * list.count)
        
        //计算tableview的高度
        if mHeight > UIUtils.getScreenHeight() * 0.8 {
            mHeight = UIUtils.getScreenHeight() * 0.8
            self.mListTableView?.scrollEnabled = true
        }else{
            mHeight = CGFloat(mCellHeight * list.count)
            self.mListTableView?.scrollEnabled = false
        }
        
        self.layer.zPosition = 1000
        self.frame = CGRectMake(0, 0, UIUtils.getScreenWidth(), UIUtils.getScreenHeight())
        self.backgroundColor = UIColor(red: 160, green: 160, blue: 160, alpha: 0)
        
      
        let mViewHeight = mHeight! + 50
        self.mView = UIView(frame: CGRectMake(0, UIUtils.getScreenHeight(), UIUtils.getScreenWidth(), CGFloat(mViewHeight)))
        self.mView.backgroundColor = UIColor(red: 160, green: 160, blue: 160, alpha: 0)
        if(self.mListTableView == nil){
            self.mListTableView = UITableView()
        }
        
        self.mListTableView?.frame =  CGRectMake(0,0, UIUtils.getScreenWidth(), mHeight!)
        self.mListTableView?.dataSource = self
        self.mListTableView?.delegate = self
        self.mListTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        self.mListTableView?.registerClass(WeiYinDownSheetCell.self, forCellReuseIdentifier: WeiYinDownSheetCell.getReuseIdentifier())
        
        self.mView.addSubview(self.mListTableView!)
        
        let bottomBtn = UIButton(frame:  CGRectMake(0,mHeight!  + 5, UIUtils.getScreenWidth(),44))
        bottomBtn.setTitle("退出制作", forState: UIControlState.Normal)
        bottomBtn.setTitleColor(UIUtils.getTextBlackColor(), forState: UIControlState.Normal)
        bottomBtn.titleLabel?.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        
        bottomBtn.addTarget(self, action: #selector(WeiYinDownSheet.cancel), forControlEvents: UIControlEvents.TouchUpInside)
        bottomBtn.setBackgroundImage(UIUtils.getImageHighlighted(), forState: UIControlState.Highlighted)
        bottomBtn.backgroundColor = UIColor.whiteColor()
        self.mView.addSubview(bottomBtn)
        self.addSubview(mView)
        
        ShowanimeData()
    }
    
    func  ShowanimeData(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WeiYinDownSheet.close))
        self.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
            self.isShowing = true
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.mView.frame = CGRectMake(self.mView.frame.origin.x, UIUtils.getScreenHeight() - self.mView.frame.size.height, self.mView.frame.size.width,self.mView.frame.size.height)
            })
        }) { (Bool) -> Void in
            
            
        }
    }
    
    func cancel(){
        close()
        if self.delegate != nil{
            self.delegate?.onSheetCancel()
        }
    }
    
    func close() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mView.frame = CGRectMake(0, UIUtils.getScreenHeight(), UIUtils.getScreenWidth(),0)
            self.alpha = 0
            self.isShowing = false
        }) { (Bool) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func ShowInView(view:UIViewController!){
        if view == nil {
        }else{
            view.view.addSubview(self)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isKindOfClass(WeiYinDownSheet.self) {
            return true
        }
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
         return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mListData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.close()
        if self.delegate != nil{
            self.delegate?.onSheetSelectIndex(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(mCellHeight)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model = mListData[indexPath.row] as! WeiYinDownSheetModel
        
        var cell = tableView.dequeueReusableCellWithIdentifier(WeiYinDownSheetCell.getReuseIdentifier(), forIndexPath: indexPath) as? WeiYinDownSheetCell
        
        if cell == nil{
            cell = WeiYinDownSheetCell()
        }
        cell?.initSheetView()
        cell?.setData(model)
        return cell!
    }
    
}
