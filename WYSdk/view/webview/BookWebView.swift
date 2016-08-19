//
//  PublicWebViewController.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 16/1/31.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import UIKit

class BookWebView : BaseUIViewController,UIWebViewDelegate{
    
    private var loadingIndicator = LoadingView()
    
    static func launch(controller:UIViewController,url:String){
        let webController = BookWebView()
        webController.mUrl = url
        controller.presentViewController(webController, animated: true, completion: nil)
    }
    
    var mPublicWebView = WYWebView()
    var mUrl = ""
    
    override func initUI() {
        setPublicWebView()
        transfromScreen()
        self.view.addSubview(loadingIndicator)
    }
    
    private func transfromScreen(){
        UIApplication.sharedApplication().setStatusBarOrientation(.LandscapeRight, animated: true)
    
        mPublicWebView.frame = CGRectMake(0, 0, UIUtils.getScreenHeight(), UIUtils.getScreenWidth())
        mPublicWebView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*0.5))
        let rect = mPublicWebView.frame
        mPublicWebView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height)
    }
    
    func setPublicWebView(){
        if mUrl.isEmpty{
            mUrl = "http://app.weiyin.cc"
        }
        let request = NSURLRequest(URL: NSURL(string: mUrl)!)
        mPublicWebView.loadRequest(request)
        mPublicWebView.delegate = self
        mPublicWebView.scalesPageToFit = true
        self.view.addSubview(mPublicWebView)
    }
    
    //返回
    func clickBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var urlString = request.URL?.absoluteString
        urlString = urlString?.stringByRemovingPercentEncoding
        
        var urlComps:[String]! = (urlString?.componentsSeparatedByString("://"))
        if(urlComps?.count > 0 && urlComps[0] == "ios"){

            var params:[String]! = urlComps[1].componentsSeparatedByString("#!#")
            
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
    
    private func addShopCart(bookId:String,count:String,workmanship:String,_ webView:UIWebView){
        
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
    
    private func loadJsFunc(webview:UIWebView,funcName:String){
        webview.stringByEvaluatingJavaScriptFromString(funcName+"()")
    }
    
    private func loadJsFunc(webview:UIWebView,funcName:String,param:String){
        webview.stringByEvaluatingJavaScriptFromString(funcName+"('"+"\(param)"+"')")
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        loadingIndicator.stop()
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        loadingIndicator.start()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        loadingIndicator.stop()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
