//
//  WYSdk.swift
//  WYSdk v1.3.0
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyUserDefaults

public class WYSdk : BaseSdk {
    
    public static let PAY_SUCCESS = "success" //  payment succeed
    public static let PAY_FAIL = "fail" // payment failed
    public static let PAY_CANCEL = "cancel" // user canceld
    public static let PAY_INVALID = "invalid" // payment plugin not installed
    
    private static var onceToken : dispatch_once_t = 0
    private static var mInstance : WYSdk?
    
    private override init(){}
    
    public static func getInstance() -> WYSdk{
        dispatch_once(&onceToken) {
            mInstance = WYSdk()
        }
        return mInstance!
    }
    
    private var accessKey = ""
    private var accessSecret = ""
    private var openId = ""
    private var identity = ""
    private var thirdName = ""
    private var thirdHeadImg = ""
    private var themeColor = "f56971"
    var host = ""
    var ip = ""
    private var channel = 0
    
    private var lastLoginTime = 0
    
    private var isMyAppPayy = false
    private var isShowDataSelectPage = true
    private var isLoadMoree = false
    
    private var selectDataPage:SelectDataViewController?
    
    var payOrderDelegate : WYPayOrderBlock?
    var refreshDelegate : WYRefreshOrderBlock?
    var payStateDelegate : WYRefreshPayBlock?
    var loadMoreDelegate : WYLoadMoreBlock?
    
    private var wyProtocol  = WYProtocol()
    private var structDataBean = RequestStructDataBean()
    
    
    /**
     * 初始化的方法
     *
     * @param accessKey    申请到的AppKey
     * @param accessSecret 申请到的AppSecret
     * @param openId       每个合作方的每个用户的唯一标识 建议写法 前缀+唯一标识 如 WY_xxxxxx
     */
    public func setSdk(accessKey:String, accessSecret:String, openId:String) {
        self.accessKey = accessKey
        self.accessSecret = accessSecret
        self.openId = openId
        
        requestIdentity(Controller(nil, nil, nil))
    }
    
    private func isLogin() -> Bool{
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
    
    private func getOpenId() -> String {
        return openId
    }
    
    public func getHost() -> String {
        UserController.getInstance().getHttpDNSIp()
        if self.ip.isEmpty{
            return host
        }else{
            return "http://" + ip + "/"
        }
    }
    
    public func isShowSelectDataVC()->Bool{
        return isShowDataSelectPage
    }
    
    /*
     设置合作方支付的回调
     */
    public func setWyPayOrderDelegate(delegate:WYPayOrderBlock){
        payOrderDelegate = delegate
    }
    
    /*
     设置上啦刷新的回调
     */
    public func setWyLoadMoreDelegate(delegate:WYLoadMoreBlock){
        loadMoreDelegate = delegate
    }
    
    public func getWyLoadMoreDelegate()->WYLoadMoreBlock?{
        return loadMoreDelegate
    }
    
    public func setRefreshOrderDelegate(delegate:WYRefreshOrderBlock){
        refreshDelegate = delegate
    }
    
    public func setRefreshPayDelegate(delegate:WYRefreshPayBlock){
        payStateDelegate = delegate
    }
    
    /*
     设置合作方支付
     */
    public func setMyAppPay(isMyAppPay:Bool){
        self.isMyAppPayy = isMyAppPay
    }
    
    public func isMyAppPay()->Bool{
        return self.isMyAppPayy
    }
    
    /*
     设置打开加载更多
     */
    public func openLoadMore(loadMore:Bool){
        self.isLoadMoree = loadMore
    }
    
    func isLoadMore()->Bool{
        return isLoadMoree
    }
    
    func setSelectDataPage(vc:SelectDataViewController?){
        selectDataPage = vc
    }
    
    /*
     打开数据选择面页
     */
    public func isShowSelectDataViewController(isShow:Bool){
        isShowDataSelectPage = isShow
    }
    
    /*
     设置第三方的名字
     */
    public func setThirdName(name:String) {
         thirdName = name
    }
    
    /*
     设置第三方的头像http路径哦
     */
    public func setThirdHeadImg(url:String) {
         thirdHeadImg = url
    }
    
    /*
     设置主题颜色 16进制颜色 如 f56971
     */
    public func setThemeColor(color:String){
        self.themeColor = color
    }
    
    public func getThemeColor()->String{
        return self.themeColor
    }
    
    public func getChannel()-> Int{
        return channel
    }
    
    private func getThirdName()-> String{
        return thirdName
    }
    
    private func getThirdHeadImg()-> String{
        return thirdHeadImg
    }
    
    private func requestIdentity(controller:Controller){
        let bean = RequestUserInfoBean()
        bean.openId = getOpenId()
        bean.name = getThirdName()
        bean.headImg = getThirdHeadImg()
        runOnAsync { 
            let resultBean = self.wyProtocol.getUserInfo(bean)
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
    
    private func fillRes(url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int,des:String)->RequestStructDataBean.Resource{
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
    public func setFrontCover(title:String,subTitle:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
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
    public func setBackCover(url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
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
    public func setFlyleaf(nick:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
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
    public func setPreface(text:String) {
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
    public func setCopyright(author:String,bookName:String) {
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
    public func addChapterBlock(title:String,des:String) {
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
    public func addPhotoBlock(desc:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
        let photoBlock = getPhotoBlock(desc, url: url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height)
        structDataBean.structData.dataBlocks.append(photoBlock)
    }
    
    
    /**
     * 添加文本页
     *
     * @param text 文本
     */
    public func addTextBlock(text:String) {
        let textBlock = getTextBlock(text)
        structDataBean.structData.dataBlocks.append(textBlock)
    }
    
    /**
     * 提交数据
     */
    public func postPrintData(vc: UIViewController,start:UIRequestStart?,success: UIRequestSuccess?,failed :UIRequestFailed?) {
        let controller = Controller(start, success, failed)
        callStart(controller)
        
        if isLogin() {
            
            if structDataBean.structData.cover.coverImgs.isEmpty || structDataBean.structData.flyleaf.headImg.url.isEmpty || structDataBean.structData.preface.text.isEmpty || structDataBean.structData.copyright.bookName.isEmpty || structDataBean.structData.backCover.coverImgs.isEmpty {
                callFailed(controller, errorMsg: "data not integrity!!")
                return
            }
            
            if isShowDataSelectPage {
                SelectDataViewController.launch(vc)
                callSuccess(controller, t: -1)
            }else{
                requestPrint(vc, failedClear: true,start: start, success: success, failed: failed)
            
            }
            
        }else{
            let c = Controller(nil, { (result) in
                
                self.postPrintData(vc,start: start, success: success, failed: failed)
                
                }, { (msg) in
                    
                    self.callFailed(controller, errorMsg: msg)
            })
            
            requestIdentity(c)
        }
    }
    
    public func requestPrint(vc: UIViewController, failedClear:Bool,start:UIRequestStart?, success: UIRequestSuccess?,failed :UIRequestFailed?){
        let controller = Controller(start, success, failed)
        
        runOnAsync({
            self.structDataBean.identity = self.getIdentity()
            let printBean = self.wyProtocol.postStructData(self.structDataBean)
            self.handleResult(printBean, controller, resultOk: {
                
                self.runOnMain({
                    self.callSuccess(controller, t: 1)
                    
                    ThreadUtils.threadOnAfterMain(100, block: {
                        if printBean!.url.containsString(self.host){
                            printBean!.url = self.getHost() + printBean!.url.stringByReplacingOccurrencesOfString(self.host, withString: "")
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
    
    public func addLoadMoreData(blockList:NSMutableArray?){
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
    public func showOrderList(vc: UIViewController){
        PublicWebViewController.launchWithOrder(vc)
    }
    
    /*
     打开购物车
     */
    public func showShopCart(vc: UIViewController){
        PublicWebViewController.launchWithShopCart(vc)
    }
    
    /*
     打开纸质画册
     */
    public func showPaper(vc: UIViewController){
        PublicWebViewController.launchWithPaper(vc)
    }
    
    /*
     刷新订单状态
     */
    public func refreshOrderState(){
        refreshDelegate?()
    }
    
    /**
     * 刷新支付结果,用来ui显示的 {@link WYSdk.PAY_SUCCESS,WYSdk.PAY_FAIL,WYSdk.PAY_CANCEL,WYSdk.PAY_INVALID}
     */
    public func refreshPayState(result:String){
        payStateDelegate?(result)
    }

    public func getPhotoBlock(desc:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) -> RequestStructDataBean.Block{
        let photoBlock =  RequestStructDataBean.Block()
        photoBlock.blockType = RequestStructDataBean.TYPE_PHOTO
        photoBlock.resource = fillRes(url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height, des: desc)
        return photoBlock
    }

    public func getChapterBlock(title:String,des:String)-> RequestStructDataBean.Block {
        let chapterBlock =  RequestStructDataBean.Block()
        chapterBlock.chapter.desc = des
        chapterBlock.chapter.title = title
        chapterBlock.blockType = RequestStructDataBean.TYPE_CHAPTER
        return chapterBlock
    }

    public func getTextBlock(text:String) -> RequestStructDataBean.Block{
        let textBlock =  RequestStructDataBean.Block()
        textBlock.text = text
        textBlock.blockType = RequestStructDataBean.TYPE_TEXT
         return textBlock
    }
    
    public func resetStructDataBean() {
        structDataBean = RequestStructDataBean()
    }
}