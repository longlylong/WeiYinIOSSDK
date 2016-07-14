//
//  EditTextViewController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/22.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

protocol WYEditTextDelegate  {
    func textViewDidChange(text:String)
}

class EditTextViewController: BaseUIViewController ,UITextViewDelegate {
    
    static func launch(vc:UIViewController,text:String,wyEditTextDelegate:WYEditTextDelegate?){
        let etvc = EditTextViewController()
        etvc.text = text
        etvc.wyEditTextDelegate = wyEditTextDelegate
        let nv = UINavigationController(rootViewController: etvc)
        vc.presentViewController(nv, animated: true, completion: nil)
    }
    
    private var text = ""
    var wyEditTextDelegate : WYEditTextDelegate!
    private var mEditView = UITextView()
    
    override func initUI() {
        setNavTextButton()
        
        mEditView = UITextView(frame: CGRectMake(10, 10, UIUtils.getScreenWidth()-20,UIUtils.getScreenHeight()-20))
        mEditView.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mEditView.textAlignment = NSTextAlignment.Left
        mEditView.delegate = self
        mEditView.text = text
        mEditView.textColor = UIUtils.getTextBlackColor()
        self.view.addSubview(mEditView)
    }
    
    func handleRightButton(){
        if wyEditTextDelegate != nil {
            wyEditTextDelegate.textViewDidChange(text)
        }
        handleLeftButton()
    }
    
    func handleLeftButton(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView){
        text = textView.text
    }
}