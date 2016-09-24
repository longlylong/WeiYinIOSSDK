//
//  EditTextViewController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/22.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

protocol WYEditTextDelegate  {
    func textViewDidChange(_ text:String)
}

class EditTextViewController: BaseUIViewController ,UITextViewDelegate {
    
    static func launch(_ vc:UIViewController,text:String,wyEditTextDelegate:WYEditTextDelegate?){
        let etvc = EditTextViewController()
        etvc.text = text
        etvc.wyEditTextDelegate = wyEditTextDelegate
        let nv = UINavigationController(rootViewController: etvc)
        vc.present(nv, animated: true, completion: nil)
    }
    
    fileprivate var text = ""
    var wyEditTextDelegate : WYEditTextDelegate!
    fileprivate var mEditView = UITextView()
    
    override func initUI() {
        setNavTextButton()
        
        mEditView = UITextView(frame: CGRect(x: 10, y: 10, width: UIUtils.getScreenWidth()-20,height: UIUtils.getScreenHeight()-20))
        mEditView.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        mEditView.textAlignment = NSTextAlignment.left
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView){
        text = textView.text
    }
}
