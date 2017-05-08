//
//  ViewController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/4/7.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    fileprivate var loadingIndicator = LoadingView()
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden  = false
        self.navigationItem.title = "微印SDK"
        
        initPrintfView()
        
        self.view.addSubview(loadingIndicator)
        
        //编辑页设置
        edit()
        
        //这个是打开订单页,需要的时候可以调用
        //WYSdk.getInstance().showOrderList(self)
        //这个是刷新订单状态的,在订单页才生效
        //WYSdk.getInstance().refreshOrderState()
        
        //设置主题颜色 16进制颜色 如 f56971
        //WYSdk.getInstance().setThemeColor("ff00ff")
        
        //myAppPay()
    }
    
    
    fileprivate func edit(){
        //打开二次编辑面页 默认是开的
        WYSdk.getInstance().isShowSelectDataViewController(true)
        
        //上啦加载更多,默认是关闭的
        //WYSdk.getInstance().openLoadMore(true)
        WYSdk.getInstance().setWyLoadMoreDelegate {
            //WYSdk.getInstance().getTextBlock //创建文本
            //WYSdk.getInstance().getChapterBlock //创建章节
            
            ThreadUtils.threadOnAfterMain(1000, block: {
                let photoUrl1 = "http://img1.3lian.com/2015/w7/90/d/1.jpg"//1500 x 1000
                let block = WYSdk.getInstance().getPhotoBlock("图片1", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: TimeUtils.getCurrentTime(), width: 1500, height: 1000)
                
                let arr = NSMutableArray()
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                arr.add(block)
                //这个是必须调用的,可空,用来关闭loading和刷新数据
                WYSdk.getInstance().addLoadMoreData(arr)
            })
        }
    }
    
    //设置合作方的app支付 默认是false
    fileprivate func myAppPay(){
        WYSdk.getInstance().setMyAppPay(true)
        WYSdk.getInstance().setWyPayOrderDelegate { (orderId, price, randomStr) in
            //处理支付
            //合作方需要 orderId randomStr 来通知微印服务器
            //支付成功后,合作方服务器调微印服务器更新支付结果,文档在联调时索取
        }
    }
    
    fileprivate func addData() {
        //图片素材 必须是网络路径 宽高也是必要的
        let frontCoverUrl = "https://image.weiyin.cc/719/185904/FD3DB404-B318-434A-9DE2-72FF157B3857@1o_800w"
        let flyleafHeadUrl = "https://image.weiyin.cc/719/185904/b6464d78-1ed9-4c4f-8fad-937a614d9893@1o_200w"
        let backCoverUrl = "https://image.weiyin.cc/719/185904/347B3767-12C6-4C60-844E-5012B1BF0F4E@1o_800w"
        
        //章节 微印代言人的图片
        let photoUrl1 = "https://image.weiyin.cc/719/185904/f8c4624e-f371-491c-b260-01aabe395685@1o_800w"
        let photoUrl2 = "https://image.weiyin.cc/719/185904/b970b0fe-79f5-4305-bd1d-6d84768b2c77@1o_800w"
        let photoUrl3 = "https://image.weiyin.cc/719/185904/8bb5a60a-443b-4c4c-821c-cc821b48efb8@1o_800w"
        let photoUrl4 = "https://image.weiyin.cc/719/185904/8e427964-961e-44f9-9ded-28d9272e3041@1o_800w"
        let photoUrl5 = "https://image.weiyin.cc/719/185904/e99a1f5e-20b4-4c5f-a059-3d1fc6940965@1o_800w"
        let photoUrl6 = "https://image.weiyin.cc/719/185904/36b1bf8f-7a23-4bb6-9a81-7517078ded82@1o_800w"
        let photoUrl7 = "https://image.weiyin.cc/719/185904/1deda7c7-817f-4995-9975-80b7e9d0075a@1o_800w"
        let photoUrl8 = "https://image.weiyin.cc/719/185904/a3424258-9ead-4264-99d9-ab38ebec967e@1o_800w"
        let photoUrl9 = "https://image.weiyin.cc/719/185904/1deda7c7-817f-4995-9975-80b7e9d0075a@1o_800w"
        let photoUrl10 = "https://image.weiyin.cc/719/185904/14d5fb62-e71d-4768-8481-05083223ac4d@1o_800w"
        let photoUrl11 = "https://image.weiyin.cc/719/185904/6da25ae9-c89c-410a-a437-8924102d1da1@1o_800w"
        
        //章节：记录旧时光的照片书
        let photoUrl12 = "https://image.weiyin.cc/719/185904/2e38af77-bf26-451a-859c-2a1383041d4d@1o_400w"
        let photoUrl12Text = "纸质书尺寸为235*235mm，对比市场上的书大小一般都是A5（21.5cm*14cm），尺寸增加25%"
        let photoUrl13 = "https://image.weiyin.cc/719/185904/557a28b6-a9fe-4978-a108-6b59ca13db10@1o_400w"
        let photoUrl13Text = "瀑布流排版：按照片顺序铺陈排版，能完整显示全部照片"
        let photoUrl14 = "https://image.weiyin.cc/719/185904/91cc8c4e-cff9-4ab0-beec-f9279408f059@1o_400w"
        let photoUrl14Text = "拼图排版：根据照片比例匹配系统模板，自动拼图排版"
        let photoUrl15 = "https://image.weiyin.cc/719/185904/8b35f243-f887-4b41-a4eb-8b52ece6e7ca@1o_400w"
        let photoUrl15Text = "内页：美感极致。纸色自然柔和，独具专利的先进涂布工艺，独特的表面质感，层次感强，是高档画册等高精印品的专业之选。"
        let photoUrl16 = "https://image.weiyin.cc/719/185904/921cc23d-293a-4939-bda1-93c5ee8aa13f@1o_400w"
        let photoUrl16Text = "内页：120克美感纸"
        let photoUrl17 = "https://image.weiyin.cc/719/185904/3ce2590a-6432-4bfe-ab74-0af8a338a918@1o_400w"
        let photoUrl17Text = "印刷：使用惠普indigo 10000高清顶级印刷。它采用HP Indigo液体电子油墨技术和独特的数字胶印工艺，能印刷出清晰的线条、绚丽夺目的图像和插图；印刷质量最高，堪比甚至超过胶印；还原性强且画质细腻。最主要，全国20多台，我们有其中一台"
        let photoUrl18 = "https://image.weiyin.cc/719/185904/7831b58e-35dd-4b8e-8ccd-120e9e8e7630@1o_400w"
        let photoUrl18Text = "内配4个护角"
        let photoUrl19 = "https://image.weiyin.cc/719/185904/30f25df8-ee53-465f-ad07-64b4b57a219e@1o_400w"
        let photoUrl19Text = photoUrl18Text
        
        //章节：文艺的照片卡片
        let photoUrl27 = "https://image.weiyin.cc/719/185904/320c0493-08bc-43bb-a48c-40ef0d50ba27@1o_400w"
        let photoUrl27Text = "卡片材质：280克珠光纸"
        let photoUrl28 = "https://image.weiyin.cc/719/185904/679b4e03-36d3-4053-8a67-8d478c9eeb17@1o_400w"
        let photoUrl28Text = "尺寸：10.75cm*7.25cm"
        let photoUrl29 = "https://image.weiyin.cc/719/185904/305fabe6-020c-461c-9564-b15d1aada91c@1o_400w"
        let photoUrl30 = "https://image.weiyin.cc/719/185904/6e431524-bbbc-47b9-a998-4b35749f5579@1o_400w"
        
        //章节：怀旧的照片冲印
        let photoUrl39 = "https://image.weiyin.cc/719/185904/c220467d-77f1-4f1d-929d-80f2ba8b93c6@1o_400w"
        let photoUrl39Text = "300克双铜纸，画质细腻，呈现生动逼真的效果"
        let photoUrl40 = "https://image.weiyin.cc/719/185904/c03b80b7-c1a0-4d61-b387-3b8b6a9429b0@1o_400w"
        let photoUrl40Text = "高品质，双面过膜，正面过压纹膜，背面过哑膜。防水防污防氧化，平整不卷边"
        let photoUrl41 = "https://image.weiyin.cc/719/185904/fb5076c7-803c-4543-b885-ac17bf856dfc@1o_400w"
        let photoUrl41Text = "大6寸（4D）：150mmX114mm"
        let photoUrl42 = "https://image.weiyin.cc/719/185904/948ad9cb-21cf-474f-832f-9223ae7d9eaa@1o_400w"
        let photoUrl42Text = "惠普indigo10000高清顶级印刷，还原照片颜色和细节。采用惠普环保电子油墨，无银盐，呵护家人健康"
        
        //章节：精美照片定制台历
        let photoUrl43 = "https://image.weiyin.cc/719/185904/104a0dd8-81b6-4a10-92b2-c98b37996acf@1o_400w"
        let photoUrl43Text = "尺寸：A5大小（横版210mmX148mm）"
        let photoUrl44 = "https://image.weiyin.cc/719/185904/8784c33e-8142-4172-b53d-b0c5f02991ca@1o_400w"
        let photoUrl44Text = "内页：采用250克铜版纸印制，纸张平滑有光泽"
        let photoUrl45 = "https://image.weiyin.cc/719/185904/462f1c85-e4d2-4092-8e8d-5956431a3404@1o_400w"
        let photoUrl45Text = "装订：采用白色双线铁圈装订，360度灵活翻阅，牢固耐用"
        let photoUrl46 = "https://image.weiyin.cc/719/185904/4d96f47c-2def-4548-b354-5af45e4a2107@1o_400w"
        let photoUrl46Text = "底座：采用超厚牛皮纸板为支撑，可以平稳的立在桌面上"
        let photoUrl47 = "https://image.weiyin.cc/719/185904/17a8fcd1-0de5-43cf-ad5e-9496269ac7d6@1o_400w"
        let photoUrl47Text = "封面"
        let photoUrl48 = "https://image.weiyin.cc/719/185904/46877022-4ef3-4e53-addf-ef71624919e7@1o_400w"
        let photoUrl48Text = "内页1图，2图随机排版"
        let photoUrl49 = "https://image.weiyin.cc/719/185904/a7860f64-7b53-48ff-afb0-541f55e14a75@1o_400w"
        let photoUrl49Text = "背面可记事"
        
        //拍摄时间,由于是网络图片就自定义了一个时间
        let originalTime = TimeUtils.getCurrentTime()
        
        
        
        
        WYSdk.getInstance().setFrontCover("一本画册看懂微印品质", subTitle: "", url: frontCoverUrl, lowPixelUrl: frontCoverUrl, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().setFlyleaf("爱微印", url: flyleafHeadUrl, lowPixelUrl: flyleafHeadUrl, originalTime: originalTime, width: 461, height: 461)
        WYSdk.getInstance().setPreface("微印，国内领先的智能图文排版引擎提供商。\n" +
            "微印画册APP，一键把手机照片做成书，可选丰富主题搭配，并提供纸质书生产、销售服务\n" +
            "微信服务号爱微印，可以一键将微信朋友圈制作成纸质画册。")
        
        WYSdk.getInstance().setCopyright("微印", bookName: "了解微印")
        WYSdk.getInstance().setBackCover(backCoverUrl, lowPixelUrl: backCoverUrl, originalTime: originalTime, width: 1500, height: 1000)
        
        WYSdk.getInstance().addChapterBlock("微印代言人", des: "")
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl2, lowPixelUrl: photoUrl2, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl3, lowPixelUrl: photoUrl3, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl4, lowPixelUrl: photoUrl4, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl5, lowPixelUrl: photoUrl5, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl6, lowPixelUrl: photoUrl6, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl7, lowPixelUrl: photoUrl7, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl8, lowPixelUrl: photoUrl8, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl9, lowPixelUrl: photoUrl9, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl10, lowPixelUrl: photoUrl10, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl11, lowPixelUrl: photoUrl11, originalTime: originalTime, width: 1500, height: 1000)
        
        WYSdk.getInstance().addChapterBlock("记录旧时光的照片书", des: "")
        WYSdk.getInstance().addPhotoBlock(photoUrl12Text, url: photoUrl12, lowPixelUrl: photoUrl12, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl13Text, url: photoUrl13, lowPixelUrl: photoUrl13, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl14Text, url: photoUrl14, lowPixelUrl: photoUrl14, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl15Text, url: photoUrl15, lowPixelUrl: photoUrl15, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl16Text, url: photoUrl16, lowPixelUrl: photoUrl16, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl17Text, url: photoUrl17, lowPixelUrl: photoUrl17, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl18Text, url: photoUrl18, lowPixelUrl: photoUrl18, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl19Text, url: photoUrl19, lowPixelUrl: photoUrl19, originalTime: originalTime, width: 1500, height: 1000)
        
        WYSdk.getInstance().addChapterBlock("文艺的照片卡片", des: "")
        
        WYSdk.getInstance().addPhotoBlock(photoUrl27Text, url: photoUrl27, lowPixelUrl: photoUrl27, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl28Text, url: photoUrl28, lowPixelUrl: photoUrl28, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl29, lowPixelUrl: photoUrl29, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl30, lowPixelUrl: photoUrl30, originalTime: originalTime, width: 1500, height: 1000)
        
        WYSdk.getInstance().addChapterBlock("怀旧的照片冲印", des: "")
        WYSdk.getInstance().addPhotoBlock(photoUrl39Text, url: photoUrl39, lowPixelUrl: photoUrl39, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl40Text, url: photoUrl40, lowPixelUrl: photoUrl40, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl41Text, url: photoUrl41, lowPixelUrl: photoUrl41, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl42Text, url: photoUrl42, lowPixelUrl: photoUrl42, originalTime: originalTime, width: 1500, height: 1000)
        
        WYSdk.getInstance().addChapterBlock("精美照片定制台历", des: "")
        WYSdk.getInstance().addPhotoBlock(photoUrl43Text, url: photoUrl43, lowPixelUrl: photoUrl43, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl44Text, url: photoUrl44, lowPixelUrl: photoUrl44, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl45Text, url: photoUrl45, lowPixelUrl: photoUrl45, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl46Text, url: photoUrl46, lowPixelUrl: photoUrl46, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl47Text, url: photoUrl47, lowPixelUrl: photoUrl47, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl48Text, url: photoUrl48, lowPixelUrl: photoUrl48, originalTime: originalTime, width: 1500, height: 1000)
        WYSdk.getInstance().addPhotoBlock(photoUrl49Text, url: photoUrl49, lowPixelUrl: photoUrl49, originalTime: originalTime, width: 1500, height: 1000)
    }
    
    fileprivate func postData(_ bookType:Int,_ makeType:Int) {
        WYSdk.getInstance().postPrintData(self, bookType: bookType,makeType: makeType,start: {
            
            self.loadingIndicator.start()
            
            }, success: { (result) in
                
                self.loadingIndicator.stop()
                
            }) { (msg) in
                
                self.loadingIndicator.stop()
                
        }
    }
    
    func printBook(){
        addData()
        postData(WYSdk.BookType_Big,WYSdk.MakeType_Simple)
    }
    
    func printA4D(){
        addData()
        postData(WYSdk.BookType_A4,WYSdk.MakeType_A4_D)
    }
    
    func printPhoto(){
        addData()
        postData(WYSdk.BookType_Big,WYSdk.MakeType_Simple)
    }
    
    func print28P(){
        addData()
        postData(WYSdk.BookType_Big,WYSdk.MakeType_28P)
    }
    
    var mPrintfingView = UIView()               //一键微印界面
    var mPrintfingBackView = UIView()               //一键微印界面
    var mCancelBtn = UIButton()
    var mPrintfText = UILabel()
    var mPrintfbookView = UIView()
    var mPrintfcardView = UIView()
    var mCancelView = UIView()
    var mPhotoGraphicView = UIView()
    var mDeskCalendarView = UIView()
    
    let PRINTF_CANCEL_BTN = 131
    let PRINTF_CALENDAR_BTN = 132
    let PRINTF_PHOTO_BTN = 133
    let PRINTF_CARD_BTN = 134
    let PRINTF_BOOK_BTN = 135
    let VIEW_HEIGHT:CGFloat = 64
    
    var mDetailStatusView = UIView()
    var mDetailStatusImage = UIImageView()
    
    func initPrintfView(){
        
        mDetailStatusView = UIView(frame: CGRect(x: UIUtils.getScreenWidth() - 70, y: UIUtils.getScreenHeight() - 70,width: 54,height: 54))
        mDetailStatusView.backgroundColor = UIColor.clear
        mDetailStatusView.layer.zPosition = 200
        mDetailStatusView.layer.cornerRadius = 27
        mDetailStatusView.layer.masksToBounds = true
        mDetailStatusImage = UIImageView(frame: CGRect(x: 0, y: 0,width: 54,height: 54))
        mDetailStatusImage.layer.zPosition = 1
        mDetailStatusImage.image = UIImage(named: "icon_printfing_white")
        mDetailStatusView.addSubview(mDetailStatusImage)
 
        let detailStatusBtn = UIButton(frame:CGRect(x: 0, y: 0,width: 54,height: 54))
        detailStatusBtn.addTarget(self, action: #selector(ViewController.photosPrintfing), for: UIControlEvents.touchUpInside)

        
        detailStatusBtn.setBackgroundImage(ImageUtils.getImageHighlighted(), for: UIControlState.highlighted)
        mDetailStatusView.addSubview(detailStatusBtn)
        self.view.addSubview(mDetailStatusView)
        
        mPrintfingView.removeFromSuperview()
        mPrintfingView = UIView(frame: CGRect(x: 0,y: 0,width: UIUtils.getScreenWidth(),height: UIUtils.getScreenHeight()))
        mPrintfingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        mPrintfingView.layer.zPosition = 1000
        mPrintfingView.isHidden = true
        
        mCancelView = UIView(frame: CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54))
        
        let cancelText = ActiveXUtils.initLabel(CGRect(x: 0, y: 0, width: 90, height: 54), fontSize: StringUtils.getTitleFontSize(), textColor: UIColor.white, textAlignment: NSTextAlignment.right)
        cancelText.text = ""
        mCancelView.addSubview(cancelText)
        mCancelBtn = ActiveXUtils.initButtonWithImage(CGRect(x: 100,y: 0,width: 54,height: 54), imageName: "icon_printf_book_cancel", target: self, action:#selector(ViewController.printfClick(_:)), events: UIControlEvents.touchUpInside)
        mCancelBtn.tag = PRINTF_CANCEL_BTN
        mCancelBtn.layer.cornerRadius = 27
        mCancelBtn.layer.masksToBounds = true
        mCancelView.addSubview(mCancelBtn)
        mPrintfingView.addSubview(mCancelView)
        
        mDeskCalendarView = UIView(frame: CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54))
        
        let deskText = ActiveXUtils.initLabel(CGRect(x: 0, y: 0, width: 100, height: 54), fontSize: StringUtils.getTitleFontSize(), textColor: UIColor.white, textAlignment: NSTextAlignment.right)
        deskText.text = "对裱影楼册"
        mDeskCalendarView.addSubview(deskText)
        let deskBtn = ActiveXUtils.initButtonWithImage(CGRect(x: 100,y: 0,width: 54,height: 54), imageName: "icon_printf_book_calendar", target: self, action:#selector(ViewController.printfClick(_:)), events: UIControlEvents.touchUpInside)
        deskBtn.tag = PRINTF_CALENDAR_BTN
        deskBtn.layer.cornerRadius = 27
        deskBtn.layer.masksToBounds = true
        mDeskCalendarView.addSubview(deskBtn)
        mPrintfingView.addSubview(mDeskCalendarView)
        
        mPhotoGraphicView = UIView(frame: CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54))
        
        let photoText = ActiveXUtils.initLabel(CGRect(x: 0, y: 0, width: 90, height: 54), fontSize: StringUtils.getTitleFontSize(), textColor: UIColor.white, textAlignment: NSTextAlignment.right)
        photoText.text = "照片冲印"
        mPhotoGraphicView.addSubview(photoText)
        let photoBtn = ActiveXUtils.initButtonWithImage(CGRect(x: 100,y: 0,width: 54,height: 54), imageName: "icon_printf_book_photo", target: self, action:#selector(ViewController.printfClick(_:)), events: UIControlEvents.touchUpInside)
        photoBtn.tag = PRINTF_PHOTO_BTN
        photoBtn.layer.cornerRadius = 27
        photoBtn.layer.masksToBounds = true
        mPhotoGraphicView.addSubview(photoBtn)
        mPrintfingView.addSubview(mPhotoGraphicView)
        
        mPrintfcardView = UIView(frame: CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54))
        
        let cardText = ActiveXUtils.initLabel(CGRect(x: 0, y: 0, width: 100, height: 54), fontSize: StringUtils.getTitleFontSize(), textColor: UIColor.white, textAlignment: NSTextAlignment.right)
        cardText.text = "对裱纪念册"
        mPrintfcardView.addSubview(cardText)
        let cardBtn = ActiveXUtils.initButtonWithImage(CGRect(x: 100,y: 0,width: 54,height: 54), imageName: "icon_printf_book_card", target: self, action:#selector(ViewController.printfClick(_:)), events: UIControlEvents.touchUpInside)
        cardBtn.tag = PRINTF_CARD_BTN
        cardBtn.layer.cornerRadius = 27
        cardBtn.layer.masksToBounds = true
        mPrintfcardView.addSubview(cardBtn)
        mPrintfingView.addSubview(mPrintfcardView)
        
        mPrintfbookView = UIView(frame: CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54))
        
        let bookText = ActiveXUtils.initLabel(CGRect(x: 0, y: 0, width: 90, height: 54), fontSize: StringUtils.getTitleFontSize(), textColor: UIColor.white, textAlignment: NSTextAlignment.right)
        bookText.text = "照片书"
        mPrintfbookView.addSubview(bookText)
        let bookBtn = ActiveXUtils.initButtonWithImage(CGRect(x: 100,y: 0,width: 54,height: 54), imageName: "icon_printf_book_big", target: self, action:#selector(ViewController.printfClick(_:)), events: UIControlEvents.touchUpInside)
        bookBtn.tag = PRINTF_BOOK_BTN
        bookBtn.layer.cornerRadius = 27
        bookBtn.layer.masksToBounds = true
        mPrintfbookView.addSubview(bookBtn)
        mPrintfingView.addSubview(mPrintfbookView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture(_:)))
        tapGesture.numberOfTouchesRequired = 1
        mPrintfingView.addGestureRecognizer(tapGesture)
        self.view.addSubview(mPrintfingView)
        //showPrintfView()
    }

    func photosPrintfing(){
        
        if mPrintfingView.isHidden {          //显示打印页
            showPrintfView()
        }else{
            dismissPrintfView()
        }
    }
    
    func tapGesture(_ sender:UITapGestureRecognizer) {
        dismissPrintfView()
    }
    
    func printfClick(_ sender:UIButton) {
        dismissPrintfView()
        ThreadUtils.threadOnAfterMain(400) {
            switch sender.tag {
            case self.PRINTF_CALENDAR_BTN:
                self.print28P()
                break
            case self.PRINTF_PHOTO_BTN:
                self.printPhoto()
                break
            case self.PRINTF_CARD_BTN:
                self.printA4D()
                break
            case self.PRINTF_BOOK_BTN:
                self.printBook()
                break
            default:
                break
            }
        }
        
    }
    
    func showPrintfView(){
        mPrintfingView.isHidden = false
        
        AnimUtils.moveViewAnimation(mCancelBtn, optName: "transform.rotation", hidden: false, distance: Double.pi / 2, durationTime: 0.2)
        
        UIView.animate(withDuration: 0.06, animations: { () -> Void in
            self.mDeskCalendarView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70 - self.VIEW_HEIGHT,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
        UIView.animate(withDuration: 0.12, animations: { () -> Void in
            self.mPrintfcardView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70 - self.VIEW_HEIGHT * 2,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
        UIView.animate(withDuration: 0.18, animations: { () -> Void in
            self.mPhotoGraphicView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70 - self.VIEW_HEIGHT * 3,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
        UIView.animate(withDuration: 0.24, animations: { () -> Void in
            self.mPrintfbookView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70 - self.VIEW_HEIGHT * 4,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
    }
    
    func dismissPrintfView(){
        AnimUtils.moveViewAnimation(mCancelBtn, optName: "transform.rotation", hidden: false, distance: -Double.pi / 2, durationTime: 0.4)
        UIView.animate(withDuration: 0.06, animations: { () -> Void in
            self.mDeskCalendarView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70 ,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
        UIView.animate(withDuration: 0.12, animations: { () -> Void in
            self.mPrintfcardView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
        
        UIView.animate(withDuration: 0.18, animations: { () -> Void in
            self.mPhotoGraphicView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70 ,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
        })
        
        UIView.animate(withDuration: 0.24, animations: { () -> Void in
            self.mPrintfbookView.frame = CGRect(x: UIUtils.getScreenWidth() - 170,y: UIUtils.getScreenHeight() - 70,width: 170,height: 54)
        }, completion: { (Bool) -> Void in
            self.mPrintfingView.isHidden = true
        })
        
    }
}
