//
//  WYSdk.swift
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import SwiftyUserDefaults

open class WYSdk : BaseSdk {
    
    open static let PAY_SUCCESS = "success" //  payment succeed
    open static let PAY_FAIL = "fail" // payment failed
    open static let PAY_CANCEL = "cancel" // user canceld
    open static let PAY_INVALID = "invalid" // payment plugin not installed
    
    
    open static let SDK_VERSION = "1.7.0"//sdk版本
    
    //成品类型需要组合
    /**
     * 大书 卡片 照片冲印 台历 A4书
     */
    open static let BookType_Big = 0
    open static let BookType_Card = 1
    open static let BookType_Photo = 3
    open static let BookType_Calendar = 4
    open static let BookType_A4 = 5
    
    open static let MakeType_Simple = 0   //简胶
    open static let MakeType_A4_D = 1     //A4对裱
    open static let MakeType_Jing = 2     //精装
    open static let MakeType_28P = 4      //28P对裱影楼册
    open static let MakeType_28P_B = 6    //布纹
    open static let MakeType_28P_M = 5    //迷你
    open static let MakeType_28P_M_B = 7  //布纹迷你
    
    fileprivate static let mInstance = WYSdk()
    
    fileprivate override init(){}
    
    open static func getInstance() -> WYSdk{
        return mInstance
    }
    
    var guid = ""
    var token = ""
    var timestamp = 0
    
    fileprivate var accessKey = ""
    fileprivate var accessSecret = ""
    fileprivate var openId = ""
    fileprivate var identity = ""
    fileprivate var thirdName = ""
    fileprivate var thirdHeadImg = ""
    fileprivate var themeColor = "f56971"

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
            let resultBean = self.mHttpStore.getUserInfo(bean: bean)
            self.handleResult(resultBean, controller, resultOk: {
                
                    self.lastLoginTime = TimeUtils.getCurrentTime()
                    self.identity = resultBean!.identity
                    self.channel = resultBean!.client
                    self.guid = resultBean!.guid
                    self.token = resultBean!.token
                    self.timestamp = resultBean!.timestamp
                    self.callSuccess(controller, t: resultBean!)
                
                }, resultFailed: {
                    
            })
        }
    }
    
    fileprivate func fillRes(_ url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int,des:String)->Resource{
        let resource = Resource()
        resource.desc = des
        resource.url = url
        resource.lowPixelUrl = lowPixelUrl
        resource.originaltime = originalTime
        resource.width = width
        resource.height = height
        return resource
    }
    
    //MARK: 添加结构化数据开始
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
        let frontCover = Cover()
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
        let backCover =  Cover()
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
        let flyleaf = Flyleaf()
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
        let preface = Preface()
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
        let copyright = Copyright()
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
     * 添加自定义一图照片页
     *
     * @param desc         照片描述
     * @param url          照片高精路径
     * @param lowPixelUrl  照片低精路径
     * @param originalTime 照片拍摄时间
     * @param width        照片宽
     * @param height       照片高
     */
    open func addOnePBlock(_ desc:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) {
        let photoBlock = getPhotoBlock(desc, url: url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height)
        photoBlock.type = RequestStructDataBean.TYPE_ONE_P
        structDataBean.structData.dataBlocks.append(photoBlock)
    }
    
    //MARK:提交数据
    /**
     * 提交数据入口 对照常量
     * 类型bookType makeType
     * {@link WYSdk.BookType_Big,WYSdk.MakeType_Simple,....}
     * 简胶大方书 0 0
     * 对裱影楼册 0 4
     * 迷你影楼册 0 5
     * 布纹影楼册 0 6
     * 迷你布纹册 0 7
     * 卡片 1 0
     * 照片冲印 3 0
     * 台历 4 0
     * 轻杂志 5 0
     * 对裱纪念册 5 1
     */
    open func postPrintData(_ vc: UIViewController,bookType:Int, makeType:Int, start:UIRequestStart?,success: UIRequestSuccess?,failed :UIRequestFailed?) {
        let controller = Controller(start, success, failed)
        callStart(controller)
        
        if isLogin() {
            
            if structDataBean.structData.cover.coverImgs.isEmpty || structDataBean.structData.backCover.coverImgs.isEmpty {
                callFailed(controller, errorMsg: "data not integrity!!")
                return
            }
            
            if AlbumHelper.checkPhotoCount(photoCount: structDataBean.structData.dataBlocks.count, bookType: bookType,makeType: makeType,datas: structDataBean.structData.dataBlocks) {
                let range = AlbumHelper.photoRange(bookType: bookType, makeType: makeType,datas: structDataBean.structData.dataBlocks)
                callFailed(controller, errorMsg: "photos count not match, the range is " + "\(range[0])-" + "\(range[1])")
                return
            }
            
            
            if isShowDataSelectPage {
                SelectDataViewController.launch(vc,bookType: bookType, makeType: makeType)
                callSuccess(controller, t: -1 as AnyObject)
            }else{
                requestPrint(vc, bookType: bookType, makeType: makeType,failedClear: true,start: start, success: success, failed: failed)
            
            }
            
        }else{
            let c = Controller(nil, { (result) in
                
                self.postPrintData(vc,bookType: bookType,makeType: makeType,start: start, success: success, failed: failed)
                
                }, { (msg) in
                    
                    self.callFailed(controller, errorMsg: msg)
            })
            
            requestIdentity(c)
        }
    }
    
    open func requestPrint(_ vc: UIViewController, bookType:Int, makeType:Int,failedClear:Bool,start:UIRequestStart?, success: UIRequestSuccess?,failed :UIRequestFailed?){
        let controller = Controller(start, success, failed)
        
        runOnAsync({
            self.structDataBean.identity = self.getIdentity()
            self.structDataBean.bookType = bookType
            self.structDataBean.makeType = makeType
            let printBean = self.mHttpStore.postStructData(bean: self.structDataBean)
            self.handleResult(printBean, controller, resultOk: {
                
                self.runOnMain({
                    self.callSuccess(controller, t: 1 as AnyObject)
                    
                    ThreadUtils.threadOnAfterMain(100, block: {
                        
                        let count = AlbumHelper.onePBlockCount(self.structDataBean.structData.dataBlocks)
                        var p = 32 - count
                        if p > 28{
                            p = 28
                        }
                        let url = printBean!.url.replacingOccurrences(of: "http://", with: "https://")
                        BookWebView.launch(vc, url:  url.replacingOccurrences(of: "fixedpnum=28", with: "fixedpnum=" + "\(p)") + "&" + HttpConstant.getToken())
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
                    structDataBean.structData.dataBlocks.append(b as! Block)
                }
            }
            selectDataPage!.addLoadMoreData(blockList)
        }
    }
    
    //MARK: 以下是打开面页的方法
    
    /*
     打开我的作品页
     */
    open func showProductList(_ vc: UIViewController){
        PublicWebViewController.launch(vc,url: HttpConstant.getShowProductListUrl())
    }
    
    
    /*
     打开订单页
     */
    open func showOrderList(_ vc: UIViewController){
        PublicWebViewController.launch(vc,url: HttpConstant.getShowOrderUrl())
    }
    
    /*
     打开购物车
     */
    open func showShopCart(_ vc: UIViewController){
        PublicWebViewController.launch(vc,url: HttpConstant.getShowCartUrl())
    }
    
    /*
     打开纸质画册
     */
    open func showPaper(_ vc: UIViewController){
        PublicWebViewController.launch(vc,url: HttpConstant.getPaperUrl())
    }
    
    /*
     打开常见问题
     */
    public func showQuestion(_ vc: UIViewController){
        PublicWebViewController.launch(vc,url: HttpConstant.getQuestionUrl())
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

    open func getPhotoBlock(_ desc:String,url:String,lowPixelUrl:String,originalTime:Int,width:Int,height:Int) -> Block{
        let photoBlock =  Block()
        photoBlock.blockType = RequestStructDataBean.TYPE_PHOTO
        photoBlock.resource = fillRes(url, lowPixelUrl: lowPixelUrl, originalTime: originalTime, width: width, height: height, des: desc)
        return photoBlock
    }

    open func getChapterBlock(_ title:String,des:String)-> Block {
        let chapterBlock =  Block()
        chapterBlock.chapter.desc = des
        chapterBlock.chapter.title = title
        chapterBlock.blockType = RequestStructDataBean.TYPE_CHAPTER
        return chapterBlock
    }

    open func getTextBlock(_ text:String) -> Block{
        let textBlock =  Block()
        textBlock.text = text
        textBlock.blockType = RequestStructDataBean.TYPE_TEXT
         return textBlock
    }
    
    open func resetStructDataBean() {
        structDataBean = RequestStructDataBean()
    }
}
