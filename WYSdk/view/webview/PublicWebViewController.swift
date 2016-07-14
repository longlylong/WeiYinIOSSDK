//
//  PublicWebViewController.swift
//  WeprintIOS
//
//  Created by WEIYIN_JJ on 16/1/31.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import UIKit
//import SwiftyUserDefaults

class PublicWebViewController : BaseUIViewController , UIWebViewDelegate{

    private var loadingIndicator = LoadingView()
    
    static func launchWithOrder(controller:UIViewController){
        let webController = PublicWebViewController()
        webController.mUrl = HttpConstant.getShowOrderUrl()
        controller.presentViewController(webController, animated: true, completion: nil)
    }
    
    static func launch(controller:UIViewController,url:String){
        let webController = PublicWebViewController()
        webController.mUrl = url
        controller.presentViewController(webController, animated: true, completion: nil)
    }
    
    var mPublicWebView = WYWebView()
    var mUrl = ""
    
     override func initUI() {
        setPublicWebView()
        self.view.addSubview(loadingIndicator)
    }

    override func initListener() {
        WYSdk.getInstance().setRefreshDelegateBlock{
            self.getOrders(self.mPublicWebView)
        }
    }
    
    func setPublicWebView(){
        if mUrl.isEmpty{
            mUrl = "http://app.weiyin.cc"
        }
        let request = NSURLRequest(URL: NSURL(string: mUrl)!)
        mPublicWebView.loadRequest(request)
        mPublicWebView.delegate = self
        mPublicWebView.scalesPageToFit = true
        mPublicWebView.frame = CGRectMake(0,20, UIUtils.getScreenWidth(), UIUtils.getScreenHeight()-20)
        self.view.addSubview(mPublicWebView)
    }
    
    //返回
    func clickBack(){
        if mPublicWebView.canGoBack {
            mPublicWebView.goBack()
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
                }else if funcName == "getOrdres"{
                    self.getOrders(webView)
                }else if funcName == "getShopCartList"{
                    self.getShopCartList(webView)
                }else if funcName == "delOrder"{
                    self.delOrder(webView, orderSerial: params[1])
                }else if funcName == "delShopCart"{
                    self.delShopCart(webView, cartId: params[1])
                }else if funcName == "payOrder"{
                    self.payOrder(webView, orderSerial: params[1], paymentPattern: params[2])
                }else if funcName == "activateCoupon"{
                    self.activateCoupon(webView, code: params[1])
                }else if funcName == "getCoupons"{
                    self.getCoupons(webView)
                }else if funcName == "createOrder"{
                    self.createOrder(webView, receiver: params[1], mobile: params[2], buyerMobile: params[3], paymentPattern: params[4], buyerMark: params[5], province: params[6], city: params[7], area: params[8], address: params[9], logistics: params[10], ticket: params[11], shopCartListJson: params[12])
                }else if funcName == "saveAddress"{
                    self.saveAddress(webView, addressInfo: params[1])
                }else if funcName == "getAddress"{
                    self.getAddress(webView)
                }else if funcName == "getChannel"{
                    self.loadJsFunc(webView, funcName: "showWebChannel",param: "\(WYSdk.getInstance().getChannel())")
                }
            })
            
        }
        return true
    }
    
    private func pay(webview:UIWebView,charge:String){
        Pingpp.createPayment(charge, viewController: self, appURLScheme: "weiyin", withCompletion: { (result, error) -> Void in
            print(result)
            
            self.goUrl(HttpConstant.getShowOrderUrl())
            
            if(error == nil){
                
            } else{
                DialogUtils.showCustomNoCancelDialog(nil, tag: 0, msg: "订单支付失败，可在订单页重新支付。", otherBtnTitle: "确定", title: "提示")
            }
        })
    }
    
    private func createOrder(webview:UIWebView,receiver:String,  mobile:String, buyerMobile:String,paymentPattern:String, buyerMark:String, province:String, city:String, area:String, address:String, logistics:String, ticket:String, shopCartListJson:String){
    
        let shopCartListBean = ShopCartListBean.toShopCartListBean(JsonUtils.toDic(shopCartListJson))
        OrderController.getInstance().createOrder(receiver, mobile: mobile, buyerMobile: buyerMark, paymentPattern: Int(paymentPattern)!, buyerMark: buyerMark, province: province, city: city, area: area, address: address, logistics: Int(logistics)!, ticket: ticket, shopCartListBean: shopCartListBean, start: {
            
                self.loadingIndicator.start()
            
            }, success: { (result) in
                
                self.loadingIndicator.stop()
                
                let payBean = result as! PayBean
                
                if payBean.isPay{
                    self.goUrl(HttpConstant.getShowOrderUrl())
                }else{
                    
                    if WYSdk.getInstance().isMyAppPay(){
                        self.goUrl(HttpConstant.getShowOrderUrl())
                        WYSdk.getInstance().payOrderDelegate?(payBean.orderSerial, payBean.price, payBean.randomKey)
                    }else{
                        self.pay(webview, charge: payBean.charge)
                    }
                    
                    
                }
                
            }) { (msg) in
                
                self.loadingIndicator.stop()
                
        }
    }
    
    private func goUrl(url:String){
        let request = NSURLRequest(URL: NSURL(string: url)!)
        self.mPublicWebView.loadRequest(request)
    }
    
    private func getCoupons(webview:UIWebView){
        OrderController.getInstance().getCoupon({ 
            
            }, success: { (result) in
                
                let coupon = result as! CouponBean
                let json = JsonUtils.toJSONString(coupon.toJson())
                self.loadJsFunc(webview, funcName: "showWebCoupon",param: json)
                
            }) { (msg) in
                
        }
    }
    
    private func activateCoupon(webview:UIWebView,code:String){
        OrderController.getInstance().activateCoupon(code, start: { 
            
            }, success: { (result) in
            
                self.getCoupons(webview)
                
            }) { (msg) in
                
        }
    }
    
    private func payOrder(webview:UIWebView,orderSerial:String,paymentPattern:String){
        OrderController.getInstance().payOrder(orderSerial, paymentPattern: Int(paymentPattern)!, start: { 
            
            }, success: { (result) in
                
                let payBean = result as! PayBean
                
                if WYSdk.getInstance().isMyAppPay(){
                    WYSdk.getInstance().payOrderDelegate?(payBean.orderSerial, payBean.price, payBean.randomKey)
                }else{
                    self.pay(webview, charge: payBean.charge)
                }
                
            }) { (msg) in
                
        }
    }
    
    private func delShopCart(webview:UIWebView,cartId:String){
        
        OrderController.getInstance().delShopCart(Int(cartId)!, start: {
            
            }, success: { (result) in
                
                self.loadJsFunc(webview, funcName: "delSuccess")
                
        }) { (msg) in
            
        }
    }
    
    private func delOrder(webview:UIWebView,orderSerial:String){
        OrderController.getInstance().delOrder(orderSerial, start: { 
            
            }, success: { (result) in
            
                self.loadJsFunc(webview, funcName: "delSuccess")
                
            }) { (msg) in
                
        }
    }
    
    private func getShopCartList(webview:UIWebView){
        OrderController.getInstance().getShopCartList({ 
            
            }, success: { (result) in
                
                let shopcart  = result as! ShopCartListBean
                let json = JsonUtils.toJSONString(shopcart.toJson())
                self.loadJsFunc(webview, funcName: "showWebShopCart", param: json)
                
            }) { (msg) in
                
        }
    }
    
    private func getOrders(webview:UIWebView){
        OrderController.getInstance().getOrderList({
            
            }, success: { (result) in
                
                let orders = result as! OrderListBean
                let json = JsonUtils.toJSONString(orders.toJson())
                self.loadJsFunc(webview, funcName: "showWebOrders", param: json)
                
            }) { (msg) in
                
        }
    }
    
    private func saveAddress(webview:UIWebView,addressInfo:String){
        Defaults[WYSdk.getInstance().getIdentity()] = addressInfo
    }
    
    private func getAddress(webview:UIWebView){
        let address = Defaults.stringForKey(WYSdk.getInstance().getIdentity()) ?? ""
        loadJsFunc(webview, funcName: "showWebAddress",param: address)
    }
    
    private func loadJsFunc(webview:UIWebView,funcName:String){
        webview.stringByEvaluatingJavaScriptFromString(funcName+"()")
    }
    
    private func loadJsFunc(webview:UIWebView,funcName:String,param:String){
        webview.stringByEvaluatingJavaScriptFromString(funcName+"('"+"\(param)"+"')")
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        loadingIndicator.stop()
        
        var urlString = webView.request?.URL?.absoluteString
        urlString = urlString?.stringByRemovingPercentEncoding
        if urlString != nil  {
            if HttpConstant.getShowCartUrl() == urlString {
                getShopCartList(webView)
            }else if HttpConstant.getShowOrderUrl() == urlString{
                getOrders(webView)
            }
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        loadingIndicator.start()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        loadingIndicator.stop()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
}
