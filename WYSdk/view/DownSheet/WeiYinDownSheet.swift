//
//  WeiYinDownSheet.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 15/9/15.
//  Copyright (c) 2015年 weiyin. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol WeiYinDownSheetDelegate:NSObjectProtocol{
    func onSheetSelectIndex(_ index:Int)
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

    func initWYDownSheet(_ list:NSMutableArray){
        self.mListData = list

        mCellHeight = 49
      
        mHeight = CGFloat(mCellHeight * list.count)
        
        //计算tableview的高度
        if mHeight > UIUtils.getScreenHeight() * 0.8 {
            mHeight = UIUtils.getScreenHeight() * 0.8
            self.mListTableView?.isScrollEnabled = true
        }else{
            mHeight = CGFloat(mCellHeight * list.count)
            self.mListTableView?.isScrollEnabled = false
        }
        
        self.layer.zPosition = 1000
        self.frame = CGRect(x: 0, y: 0, width: UIUtils.getScreenWidth(), height: UIUtils.getScreenHeight())
        self.backgroundColor = UIColor(red: 160, green: 160, blue: 160, alpha: 0)
        
      
        let mViewHeight = mHeight! + 50
        self.mView = UIView(frame: CGRect(x: 0, y: UIUtils.getScreenHeight(), width: UIUtils.getScreenWidth(), height: CGFloat(mViewHeight)))
        self.mView.backgroundColor = UIColor(red: 160, green: 160, blue: 160, alpha: 0)
        if(self.mListTableView == nil){
            self.mListTableView = UITableView()
        }
        
        self.mListTableView?.frame =  CGRect(x: 0,y: 0, width: UIUtils.getScreenWidth(), height: mHeight!)
        self.mListTableView?.dataSource = self
        self.mListTableView?.delegate = self
        self.mListTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.mListTableView?.register(WeiYinDownSheetCell.self, forCellReuseIdentifier: WeiYinDownSheetCell.getReuseIdentifier())
        
        self.mView.addSubview(self.mListTableView!)
        
        let bottomBtn = UIButton(frame:  CGRect(x: 0,y: mHeight!  + 5, width: UIUtils.getScreenWidth(),height: 44))
        bottomBtn.setTitle("退出制作", for: UIControlState())
        bottomBtn.setTitleColor(UIUtils.getTextBlackColor(), for: UIControlState())
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        
        bottomBtn.addTarget(self, action: #selector(WeiYinDownSheet.cancel), for: UIControlEvents.touchUpInside)
        bottomBtn.setBackgroundImage(UIUtils.getImageHighlighted(), for: UIControlState.highlighted)
        bottomBtn.backgroundColor = UIColor.white
        self.mView.addSubview(bottomBtn)
        self.addSubview(mView)
        
        ShowanimeData()
    }
    
    func  ShowanimeData(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WeiYinDownSheet.close))
        self.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            
            self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
            self.isShowing = true
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.mView.frame = CGRect(x: self.mView.frame.origin.x, y: UIUtils.getScreenHeight() - self.mView.frame.size.height, width: self.mView.frame.size.width,height: self.mView.frame.size.height)
            })
        }, completion: { (Bool) -> Void in
            
            
        }) 
    }
    
    func cancel(){
        close()
        if self.delegate != nil{
            self.delegate?.onSheetCancel()
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.mView.frame = CGRect(x: 0, y: UIUtils.getScreenHeight(), width: UIUtils.getScreenWidth(),height: 0)
            self.alpha = 0
            self.isShowing = false
        }, completion: { (Bool) -> Void in
            self.removeFromSuperview()
        }) 
    }
    
    func ShowInView(_ view:UIViewController!){
        if view == nil {
        }else{
            view.view.addSubview(self)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isKind(of: WeiYinDownSheet.self) {
            return true
        }
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mListData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.close()
        if self.delegate != nil{
            self.delegate?.onSheetSelectIndex((indexPath as NSIndexPath).row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(mCellHeight)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = mListData[(indexPath as NSIndexPath).row] as! WeiYinDownSheetModel
        
        var cell = tableView.dequeueReusableCell(withIdentifier: WeiYinDownSheetCell.getReuseIdentifier(), for: indexPath) as? WeiYinDownSheetCell
        
        if cell == nil{
            cell = WeiYinDownSheetCell()
        }
        cell?.initSheetView()
        cell?.setData(model)
        return cell!
    }
    
}
