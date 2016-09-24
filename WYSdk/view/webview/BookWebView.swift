//
//  PublicWebViewController.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 16/1/31.
//  Copyright © 2016年 weiyin. All rights reserved.
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


class BookWebView : BaseUIViewController,UIWebViewDelegate{
    
    fileprivate var loadingIndicator = LoadingView()
    
    static func launch(_ controller:UIViewController,url:String){
        let webController = BookWebView()
        webController.mUrl = url
        controller.present(webController, animated: true, completion: nil)
    }
    
    var mPublicWebView = WYWebView()
    var mUrl = ""
    
    override func initUI() {
        setPublicWebView()
        transfromScreen()
        self.view.addSubview(loadingIndicator)
    }
    
    fileprivate func transfromScreen(){
        UIApplication.shared.setStatusBarOrientation(.landscapeRight, animated: true)
    
        mPublicWebView.frame = CGRect(x: 0, y: 0, width: UIUtils.getScreenHeight(), height: UIUtils.getScreenWidth())
        mPublicWebView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*0.5))
        let rect = mPublicWebView.frame
        mPublicWebView.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
    }
    
    func setPublicWebView(){
        if mUrl.isEmpty{
            mUrl = "http://app.weiyin.cc"
        }
        let request = URLRequest(url: URL(string: mUrl)!)
        mPublicWebView.loadRequest(request)
        mPublicWebView.delegate = self
        mPublicWebView.scalesPageToFit = true
        self.view.addSubview(mPublicWebView)
    }
    
    //返回
    func clickBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var urlString = request.url?.absoluteString
        urlString = urlString?.removingPercentEncoding
        
        var urlComps:[String]! = (urlString?.components(separatedBy: "://"))
        if(urlComps?.count > 0 && urlComps[0] == "ios"){

            var params:[String]! = urlComps[1].components(separatedBy: "#!#")
            
            let funcName = params[0]
            
            ThreadUtils.threadOnMain({ () -> Void in
                if funcName == "closeWebView"{
                    self.clickBack()
                }else if funcName == "addShopCart"{
                    if params.count >= 4{
                        self.addShopCart(params[1], count: params[2],workmanship: params[3], webView)
                    }else{
                        self.addShopCart(params[1], count: params[2],workmanship: "0", webView)
                    }
                }else if funcName == "getChannel"{
                    self.loadJsFunc(webView, funcName: "showWebChannel",param: "\(WYSdk.getInstance().getChannel())")
                    
                }else if funcName == "getThemeColor"{
                    self.loadJsFunc(webView, funcName: "showWebThemeColor",param: WYSdk.getInstance().getThemeColor())
                }
            })
            
        }
        return true
    }
    
    fileprivate func addShopCart(_ bookId:String,count:String,workmanship:String,_ webView:UIWebView){
        
        if(bookId.isEmpty || bookId == "null"){
            loadingIndicator.stop()
            return
        }
        
        OrderController.getInstance().addShopCart(Int(bookId)!, count: Int(count)!,workmanship: Int(workmanship) ?? 0, start: { () -> Void in
            self.loadingIndicator.start()
            }, success: { (result) -> Void in
                
                self.loadingIndicator.stop()
                PublicWebViewController.launch(self, url: HttpConstant.getShowCartUrl())
                
                
        }) { (error) -> Void in
             self.loadingIndicator.stop()
        }
    }
    
    fileprivate func loadJsFunc(_ webview:UIWebView,funcName:String){
        webview.stringByEvaluatingJavaScript(from: funcName+"()")
    }
    
    fileprivate func loadJsFunc(_ webview:UIWebView,funcName:String,param:String){
        webview.stringByEvaluatingJavaScript(from: funcName+"('"+"\(param)"+"')")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        loadingIndicator.stop()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        loadingIndicator.start()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        loadingIndicator.stop()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
