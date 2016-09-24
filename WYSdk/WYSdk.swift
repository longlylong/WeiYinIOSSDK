//
//  WYSdk.swift
//  WYSdk v1.4.0
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyUserDefaults

open class WYSdk : BaseSdk {
    
    private static var __once: () = {
            mInstance = WYSdk()
        }()
    
    open static let PAY_SUCCESS = "success" //  payment succeed
    open static let PAY_FAIL = "fail" // payment failed
    open static let PAY_CANCEL = "cancel" // user canceld
    open static let PAY_INVALID = "invalid" // payment plugin not installed
    
    //成品类型
    open static let Print_Book = 0// 成书
    open static let Print_Card = 1// 成卡片
    open static let Print_Photo = 3// 照片冲印
    open static let Print_Calendar = 4// 台历
    
    fileprivate static var onceToken : Int = 0
    fileprivate static var mInstance : WYSdk?
    
    fileprivate override init(){}
    
    open static func getInstance() -> WYSdk{
        _ = WYSdk.__once
        return mInstance!
    }
    
    fileprivate var accessKey = ""
    fileprivate var accessSecret = ""
    fileprivate var openId = ""
    fileprivate var identity = ""
    fileprivate var thirdName = ""
    fileprivate var thirdHeadImg = ""
    fileprivate var themeColor = "f56971"
    var host = ""
    var ip = ""
    fileprivate var channel = 0
    
    fileprivate var lastLoginTime = 0
    
    fileprivate var isMyAppPayy = false
    fileprivate var isShowDataSelectPage = true
    fileprivate var isLoadMoree = false
    
    fileprivate var selectDataPage:SelectDataViewController?
    
    var payOrderDelegate : WYPayOrderBlock?
    var refreshDelegate : WYRefreshOrderBlock?
    var payStateDelegate : WYRefreshPayBlock?
    var loadMoreDelegate : WYLoadMoreBlock?
    
    fileprivate var wyProtocol  = WYProtocol()
    fileprivate var structDataBean = RequestStructDataBean()
    
    
    /**
     * 初始化的方法
     *
     * @param accessKey    申请到的AppKey
     * @param accessSecret 申请到的AppSecret
     * @param openId       每个合作方的每个用户的唯一标识 建议写法 前缀+唯一标识 如 WY_xxxxxx
     */
    open func setSdk(_ accessKey:String, accessSecret:String, openId:String) {
        self.accessKey = accessKey
        self.accessSecret = accessSecret
        self.openId = openId
        
        requestIdentity(Controller(nil, nil, nil))
    }
    
    fileprivate func isLogin() -> Bool{
        return !getIdentity().isEmpty && lastLoginTime + 2*60*60 > TimeUtils.getCurrentTime()
    }
    
    func getStructData() -> RequestStructDataBean {
        return structDataBean
    }
    
    func getAccessKey() -> String {
        return accessKey
    }
    
    func getAccessSecret() -> String{
        return accessSecret
    }
    
    func getIdentity() -> String{
        return identity
    }
    
    fileprivate func getOpenId() -> String {
        return openId
    }
    
    open func getHost() -> String {
        UserController.getInstance().getHttpDNSIp()
        if self.ip.isEmpty{
            return host
        }else{
            return "http://" + ip + "/"
        }
    }
    
    open func isShowSelectDataVC()->Bool{
        return isShowDataSelectPage
    }
    
    /*
     设置合作方支付的回调
     */
    open func setWyPayOrderDelegate(_ delegate:@escaping WYPayOrderBlock){
        payOrderDelegate = delegate
    }
    
    /*
     设置上啦刷新的回调
     */
    open func setWyLoadMoreDelegate(_ delegate:@escaping WYLoadMoreBlock){
        loadMoreDelegate = delegate
    }
    
    open func getWyLoadMoreDelegate()->WYLoadMoreBlock?{
        return loadMoreDelegate
    }
    
    open func setRefreshOrderDelegate(_ delegate:@escaping WYRefreshOrderBlock){
        refreshDelegate = delegate
    }
    
    open func setRefreshPayDelegate(_ delegate:@escaping WYRefreshPayBlock){
        payStateDelegate = delegate
    }
    
    /*
     设置合作方支付
     */
    open func setMyAppPay(_ isMyAppPay:Bool){
        self.isMyAppPayy = isMyAppPay
    }
    
    open func isMyAppPay()->Bool{
        return self.isMyAppPayy
    }
    
    /*
     设置打开加载更多
     */
    open func openLoadMore(_ loadMore:Bool){
        self.isLoadMoree = loadMore
    }
    
    func isLoadMore()->Bool{
        return isLoadMoree
    }
    
    func setSelectDataPage(_ vc:SelectDataViewController?){
        selectDataPage = vc
    }
    
    /*
     打开数据选择面页
     */
    open func isShowSelectDataViewController(_ isShow:Bool){
        isShowDataSelectPage = isShow
    }
    
    /*
     设置第三方的名字
     */
    open func setThirdName(_ name:String) {
         thirdName = name
    }
    
    /*
     设置第三方的头像http路径哦
     */
    open func setThirdHeadImg(_ url:String) {
         thirdHeadImg = url
    }
    
    /*
     设置主题颜色 16进制颜色 如 f56971
     */
    open func setThemeColor(_ color:String){
        self.themeColor = color
    }
    
    open func getThemeColor()->String{
        return self.themeColor
    }
    
    open func getChannel()-> Int{
        return channel
    }
    
    fileprivate func getThirdName()-> String{
        return thirdName
    }
    
    fileprivate func getThirdHeadImg()-> String{
        return thirdHeadImg
    }
    
    fileprivate func requestIdentity(_ controller:Controller){
        let bean = RequestUserInfoBean()
        bean.openId = getOpenId()
        bean.name = getThirdName()
        bean.headImg = getThirdHeadImg()
        runOnAsync { 
            let resultBean = self.wyProtocol.getUserInfo(bean: bean)
            self.handleResult(resultBean, controller, resultOk: {
                
                    self.lastLoginTime = TimeUtils.getCurrentTime()
                    self.identity = resultBean!.identity
                    self.channel = resultBean!.client
                    self.host = resultBean!.host
                    self.callSuccess(controller, t: resultBean!)
                
                    UserController.getInstance().getHttpDNSIp()
                }, resultFailed: {
                    
            })
        }
    }
    
    fileprivate func fillRes(_ url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int,des:String)->RequestStructDataBean.Resource{
        let resource = RequestStructDataBean.Resource()
        resource.desc = des
        resource.url = url
        resource.lowPixelUrl = lowPixelUrl
        resource.originaltime = originalTime
        resource.width = width
        resource.height = height
        return resource
    }
    
    
    /**
     * 设置封面
     *
     * @param title        封面标题
     * @param subTitle     封面副标题(可选)
     * @param url          封面高精图片路径
     * @param lowPixelUrl  封面低精图片路径
     * @param originalTime 封面照片的拍摄时间
     * @param width        封面照片宽
     * @param height       封面照片高
     */
    open func setFrontCover(_ title:String,subTitle:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
        let frontCover = RequestStructDataBean.Cover()
        frontCover.title = title
        frontCover.subTitle = subTitle
        frontCover.coverImgs.append(fillRes(url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height, des: ""))
        structDataBean.structData.cover = frontCover
    }
    
    /**
     * 设置封底
     *
     * @param url          封底高精图片路径
     * @param lowPixelUrl  封底低精图片路径
     * @param originalTime 封底照片的拍摄时间
     * @param width        封底照片宽
     * @param height       封底照片高
     */
    open func setBackCover(_ url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
        let backCover =  RequestStructDataBean.Cover()
        backCover.coverImgs.append(fillRes(url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height, des: ""))
        structDataBean.structData.backCover = backCover
    }
    
    
    /**
     * 设置扉页
     *
     * @param nick         扉页昵称
     * @param url          扉页高精图片路径
     * @param lowPixelUrl  扉页低精图片路径
     * @param originalTime 扉页照片的拍摄时间
     * @param width        扉页照片宽
     * @param height       扉页照片高
     */
    open func setFlyleaf(_ nick:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
        let flyleaf =  RequestStructDataBean.Flyleaf()
        flyleaf.nick = nick
        flyleaf.headImg = fillRes(url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height, des: "")
        structDataBean.structData.flyleaf = flyleaf
    }
    
    
    /**
     * 设置序言
     *
     * @param text 序言文本
     */
    open func setPreface(_ text:String) {
        let preface =  RequestStructDataBean.Preface()
        preface.text = text
        structDataBean.structData.preface = preface
    }
    
    
    /**
     * 设置版权页
     *
     * @param author   版权页作者
     * @param bookName 版权页书名
     */
    open func setCopyright(_ author:String,bookName:String) {
        let copyright =  RequestStructDataBean.Copyright()
        copyright.author = author
        copyright.bookName = bookName
        structDataBean.structData.copyright = copyright
    }
    
    
    /**
     * 添加章节页
     *
     * @param title 章节标题
     * @param des   章节描述
     */
    open func addChapterBlock(_ title:String,des:String) {
        let chapterBlock = getChapterBlock(title, des: des)
        structDataBean.structData.dataBlocks.append(chapterBlock)
    }
    
    
    /**
     * 添加照片页
     *
     * @param desc         照片描述
     * @param url          照片高精路径
     * @param lowPixelUrl  照片低精路径
     * @param originalTime 照片拍摄时间
     * @param width        照片宽
     * @param height       照片高
     */
    open func addPhotoBlock(_ desc:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
        let photoBlock = getPhotoBlock(desc, url: url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height)
        structDataBean.structData.dataBlocks.append(photoBlock)
    }
    
    
    /**
     * 添加文本页
     *
     * @param text 文本
     */
    open func addTextBlock(_ text:String) {
        let textBlock = getTextBlock(text)
        structDataBean.structData.dataBlocks.append(textBlock)
    }
    
    /**
     * 提交数据
     */
    open func postPrintData(_ vc: UIViewController,bookType:Int,start:UIRequestStart?,success: UIRequestSuccess?,failed :UIRequestFailed?) {
        let controller = Controller(start, success, failed)
        callStart(controller)
        
        if isLogin() {
            
            if structDataBean.structData.cover.coverImgs.isEmpty || structDataBean.structData.flyleaf.headImg.url.isEmpty || structDataBean.structData.preface.text.isEmpty || structDataBean.structData.copyright.bookName.isEmpty || structDataBean.structData.backCover.coverImgs.isEmpty {
                callFailed(controller, errorMsg: "data not integrity!!")
                return
            }
            
            if isShowDataSelectPage {
                SelectDataViewController.launch(vc,bookType: bookType)
                callSuccess(controller, t: -1 as AnyObject)
            }else{
                requestPrint(vc, bookType: bookType,failedClear: true,start: start, success: success, failed: failed)
            
            }
            
        }else{
            let c = Controller(nil, { (result) in
                
                self.postPrintData(vc,bookType: bookType,start: start, success: success, failed: failed)
                
                }, { (msg) in
                    
                    self.callFailed(controller, errorMsg: msg)
            })
            
            requestIdentity(c)
        }
    }
    
    open func requestPrint(_ vc: UIViewController, bookType:Int,failedClear:Bool,start:UIRequestStart?, success: UIRequestSuccess?,failed :UIRequestFailed?){
        let controller = Controller(start, success, failed)
        
        runOnAsync({
            self.structDataBean.identity = self.getIdentity()
            self.structDataBean.bookType = bookType
            let printBean = self.wyProtocol.postStructData(bean: self.structDataBean)
            self.handleResult(printBean, controller, resultOk: {
                
                self.runOnMain({
                    self.callSuccess(controller, t: 1 as AnyObject)
                    
                    ThreadUtils.threadOnAfterMain(100, block: {
                        if printBean!.url.contains(self.host){
                            printBean!.url = self.getHost() + printBean!.url.replacingOccurrences(of: self.host, with: "")
                        }
                        
                        BookWebView.launch(vc, url: printBean!.url)
                        self.setSelectDataPage(nil)
                        self.resetStructDataBean()
                    })
                    
                })
                
                }, resultFailed: {
                    if failedClear{
                        self.resetStructDataBean()
                    }
            })
        })
    }
    
    open func addLoadMoreData(_ blockList:NSMutableArray?){
        if selectDataPage != nil {
            if blockList != nil {
                for b in blockList! {
                    structDataBean.structData.dataBlocks.append(b as! RequestStructDataBean.Block)
                }
            }
            selectDataPage!.addLoadMoreData(blockList)
        }
    }
    
    /*
     打开订单页
     */
    open func showOrderList(_ vc: UIViewController){
        PublicWebViewController.launchWithOrder(vc)
    }
    
    /*
     打开购物车
     */
    open func showShopCart(_ vc: UIViewController){
        PublicWebViewController.launchWithShopCart(vc)
    }
    
    /*
     打开纸质画册
     */
    open func showPaper(_ vc: UIViewController){
        PublicWebViewController.launchWithPaper(vc)
    }
    
    /*
     刷新订单状态
     */
    open func refreshOrderState(){
        refreshDelegate?()
    }
    
    /**
     * 刷新支付结果,用来ui显示的 {@link WYSdk.PAY_SUCCESS,WYSdk.PAY_FAIL,WYSdk.PAY_CANCEL,WYSdk.PAY_INVALID}
     */
    open func refreshPayState(_ result:String){
        payStateDelegate?(result)
    }

    open func getPhotoBlock(_ desc:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) -> RequestStructDataBean.Block{
        let photoBlock =  RequestStructDataBean.Block()
        photoBlock.blockType = RequestStructDataBean.TYPE_PHOTO
        photoBlock.resource = fillRes(url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height, des: desc)
        return photoBlock
    }

    open func getChapterBlock(_ title:String,des:String)-> RequestStructDataBean.Block {
        let chapterBlock =  RequestStructDataBean.Block()
        chapterBlock.chapter.desc = des
        chapterBlock.chapter.title = title
        chapterBlock.blockType = RequestStructDataBean.TYPE_CHAPTER
        return chapterBlock
    }

    open func getTextBlock(_ text:String) -> RequestStructDataBean.Block{
        let textBlock =  RequestStructDataBean.Block()
        textBlock.text = text
        textBlock.blockType = RequestStructDataBean.TYPE_TEXT
         return textBlock
    }
    
    open func resetStructDataBean() {
        structDataBean = RequestStructDataBean()
    }
}
