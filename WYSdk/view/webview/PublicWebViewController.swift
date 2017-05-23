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

//import SwiftyUserDefaults

class PublicWebViewController : BaseUIViewController , UIWebViewDelegate{

    fileprivate var loadingIndicator = LoadingView()
    fileprivate var mBackButton : UIButton!
    
    static func launch(_ controller:UIViewController,url:String){
        let webController = PublicWebViewController()
        webController.mUrl = url
        webController.lastVC = controller
        controller.present(webController, animated: true, completion: nil)
    }
    
    var mPublicWebView = WYWebView()
    var mUrl = ""
    var lastVC:UIViewController!
    
     override func initUI() {
        setPublicWebView()
        mBackButton = getIconButton(CGRect(x: 9,y: 28,width: 24,height: 24), iconName: "icon_cancel", action: #selector(PublicWebViewController.clickBack))
        self.view.addSubview(loadingIndicator)
        
        lastVC.dismiss(animated: false, completion: nil)
    }

    override func initListener() {
        WYSdk.getInstance().setRefreshOrderDelegate{
            self.getOrders(self.mPublicWebView)
        }
        
        WYSdk.getInstance().setRefreshPayDelegate { (result) in
            self.loadJsFunc(self.mPublicWebView, funcName: "showPayResult", param: result)
        }
    }
    
    func setPublicWebView(){
        if mUrl.isEmpty{
            mUrl = "http://app.weiyin.cc"
        }
        let request = URLRequest(url: URL(string: mUrl)!)
        mPublicWebView.loadRequest(request)
        mPublicWebView.delegate = self
        mPublicWebView.scalesPageToFit = true
        mPublicWebView.frame = CGRect(x: 0,y: 20, width: UIUtils.getScreenWidth(), height: UIUtils.getScreenHeight()-20)
        self.view.addSubview(mPublicWebView)
    }
    
    //返回
    func clickBack(){
//        if mPublicWebView.canGoBack {
//            mPublicWebView.goBack()
//        }else{
            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var urlString = request.url?.absoluteString
        urlString = urlString?.removingPercentEncoding
        
        let hasIos = urlString?.contains("ios://")
        
        if hasIos != nil && hasIos!{
            
            var params:[String]! = urlString?.replacingOccurrences(of: "ios://", with: "").components(separatedBy: "#!#")
            
            let funcName = params[0]
            
            ThreadUtils.threadOnMain({ () -> Void in
                if funcName == "closeWebView"{
                    self.clickBack()
                    
                }else if funcName == "getProductList"{
                    self.getProductList(webView)
                    
                }else if funcName == "getOrdres"{
                    self.getOrders(webView)
                    
                }else if funcName == "getShopCartList"{
                    self.getShopCartList(webView)
                    
                }else if funcName == "delProduct"{
                    self.delProduct(webView, serial: params[1])
                    
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
                    
                }else if funcName == "goUrl"{
                    self.handleGoUrl(params[1])
                    
                }else if funcName == "getThemeColor"{
                    self.loadJsFunc(webView, funcName: "showWebThemeColor",param: WYSdk.getInstance().getThemeColor())
                    
                }else if funcName == "addShopCart"{
                    if params.count >= 4{
                        self.addShopCart(params[1], count: params[2],maketype: params[3], webView)
                    }else{
                        self.addShopCart(params[1], count: params[2],maketype: "0", webView)
                    }
                    
                }else if funcName == "goBookWebView"{
                    self.goBookWebView(params[1])
                }
            })
            
        }
        return true
    }
    
    private func goBookWebView(_ url:String){
        BookWebView.launch(self, url: url)
    }
    
    fileprivate func addShopCart(_ bookId:String,count:String,maketype:String,_ webView:UIWebView){
        
        if(bookId.isEmpty || bookId == "null"){
            loadingIndicator.stop()
            return
        }
        
        OrderController.getInstance().addShopCart(Int(bookId)!, count: Int(count)!,workmanship: Int(maketype) ?? 0, start: { () -> Void in
            self.loadingIndicator.start()
        }, success: { (result) -> Void in
            
            self.loadingIndicator.stop()
            PublicWebViewController.launch(self, url: HttpConstant.getShowCartUrl())
            
            
        }) { (error) -> Void in
            self.loadingIndicator.stop()
        }
    }
    
    fileprivate func getProductList(_ webview:UIWebView){
        ProductController.getInstance().getProductList({ 
            
        }, success: { (result) in
            
            let productList = result as! ProductListBean
            let json = JsonUtils.toJSONString(productList.toJson() as NSDictionary)
            self.loadJsFunc(webview, funcName: "showWebProductList",param: json)
            
        }) { (msg) in
            
        }
    }
    
    fileprivate func delProduct(_ webview:UIWebView,serial:String){
        ProductController.getInstance().delProduct(serial, start: {
            
        }, success: { (result) in
            self.loadJsFunc(webview, funcName: "delSuccess")
        }) { (msg) in
            
        }
    }
    
    fileprivate func pay(_ webview:UIWebView,charge:String){
        Pingpp.createPayment(charge as NSObject!, viewController: self, appURLScheme: "weiyin", withCompletion: { (result, error) -> Void in
            print(result ?? "")
            
            if(error == nil){
                self.loadJsFunc(webview, funcName: "showPayResult", param: WYSdk.PAY_SUCCESS)
            } else{
                self.loadJsFunc(webview, funcName: "showPayResult", param: result!)
            }
        })
    }
    
    fileprivate func createOrder(_ webview:UIWebView,receiver:String,  mobile:String, buyerMobile:String,paymentPattern:String, buyerMark:String, province:String, city:String, area:String, address:String, logistics:String, ticket:String, shopCartListJson:String){
    
        let shopCartListBean = ShopCartListBean.toShopCartListBean(jsonData: JsonUtils.toDic(shopCartListJson))
        OrderController.getInstance().createOrder(receiver, mobile: mobile, buyerMobile: buyerMark, paymentPattern: Int(paymentPattern)!, buyerMark: buyerMark, province: province, city: city, area: area, address: address, logistics: Int(logistics)!, ticket: ticket, shopCartListBean: shopCartListBean, start: {
            
                self.loadingIndicator.start()
            
            }, success: { (result) in
                
                self.loadingIndicator.stop()
                
                let payBean = result as! PayBean
                
                if payBean.isPay{
                    self.goUrl(HttpConstant.getShowOrderUrl())
                }else{
                    
                    if WYSdk.getInstance().isMyAppPay(){
                        WYSdk.getInstance().payOrderDelegate?(payBean.orderSerial, payBean.price, payBean.randomKey)
                    }else{
                        self.pay(webview, charge: payBean.charge)
                    }
                    
                    
                }
                
            }) { (msg) in
                
                self.loadingIndicator.stop()
                
        }
    }
    
    fileprivate func handleGoUrl(_ url:String){
        var target = "http://" + url
        if url == "shopcart" {
            target = HttpConstant.getShowCartUrl()
        }else if url == "paper"{
            target = HttpConstant.getPaperUrl()
        }else if url == "order"{
            target = HttpConstant.getShowOrderUrl()
        }
        goUrl(target)
    }
    
    fileprivate func goUrl(_ url:String){
        let request = URLRequest(url: URL(string: url)!)
        self.mPublicWebView.loadRequest(request)
    }
    
    fileprivate func getCoupons(_ webview:UIWebView){
        OrderController.getInstance().getCoupon({ 
            
            }, success: { (result) in
                
                let coupon = result as! CouponBean
                let json = JsonUtils.toJSONString(coupon.toJson() as NSDictionary)
                self.loadJsFunc(webview, funcName: "showWebCoupon",param: json)
                
            }) { (msg) in
                
        }
    }
    
    fileprivate func activateCoupon(_ webview:UIWebView,code:String){
        OrderController.getInstance().activateCoupon(code, start: { 
            
            }, success: { (result) in
            
                self.getCoupons(webview)
                
            }) { (msg) in
                
        }
    }
    
    fileprivate func payOrder(_ webview:UIWebView,orderSerial:String,paymentPattern:String){
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
    
    fileprivate func delShopCart(_ webview:UIWebView,cartId:String){
        
        OrderController.getInstance().delShopCart(Int(cartId)!, start: {
            
            }, success: { (result) in
                
                self.loadJsFunc(webview, funcName: "delSuccess")
                
        }) { (msg) in
            
        }
    }
    
    fileprivate func delOrder(_ webview:UIWebView,orderSerial:String){
        OrderController.getInstance().delOrder(orderSerial, start: { 
            
            }, success: { (result) in
            
                self.loadJsFunc(webview, funcName: "delSuccess")
                
            }) { (msg) in
                
        }
    }
    
    fileprivate func getShopCartList(_ webview:UIWebView){
        OrderController.getInstance().getShopCartList({ 
            
            }, success: { (result) in
                
                let shopcart  = result as! ShopCartListBean
                let json = JsonUtils.toJSONString(shopcart.toJson() as NSDictionary)
                self.loadJsFunc(webview, funcName: "showWebShopCart", param: json)
                
            }) { (msg) in
                
        }
    }
    
    fileprivate func getOrders(_ webview:UIWebView){
        OrderController.getInstance().getOrderList({
            
            }, success: { (result) in
                
                let orders = result as! OrderListBean
                let json = JsonUtils.toJSONString(orders.toJson() as NSDictionary)
                self.loadJsFunc(webview, funcName: "showWebOrders", param: json)
                
            }) { (msg) in
                
        }
    }
    
    fileprivate func saveAddress(_ webview:UIWebView,addressInfo:String){
        Defaults[WYSdk.getInstance().getIdentity()] = addressInfo
    }
    
    fileprivate func getAddress(_ webview:UIWebView){
        let address = Defaults.string(forKey: WYSdk.getInstance().getIdentity()) ?? ""
        loadJsFunc(webview, funcName: "showWebAddress",param: address)
    }
    
    fileprivate func loadJsFunc(_ webview:UIWebView,funcName:String){
        webview.stringByEvaluatingJavaScript(from: funcName+"()")
    }
    
    fileprivate func loadJsFunc(_ webview:UIWebView,funcName:String,param:String){
        webview.stringByEvaluatingJavaScript(from: funcName+"('"+"\(param)"+"')")
    }
    
    //MARK: webview 生命周期
    func webViewDidFinishLoad(_ webView: UIWebView){
        loadingIndicator.stop()
        mBackButton.removeFromSuperview()
        
        var urlString = webView.request?.url?.absoluteString
        urlString = urlString?.removingPercentEncoding
        if urlString != nil  {
            if HttpConstant.getShowCartUrl() == urlString {
                getShopCartList(webView)
            }else if HttpConstant.getShowOrderUrl() == urlString{
                getOrders(webView)
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        loadingIndicator.start()
        self.view.addSubview(mBackButton)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        loadingIndicator.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
