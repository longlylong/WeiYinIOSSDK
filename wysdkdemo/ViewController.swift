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
    
    private var loadingIndicator = LoadingView()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden  = false
        self.navigationItem.title = "demo"
        
        let mSubmitDataButton =  UIButton(frame: CGRectMake(0,0,200,200))
        mSubmitDataButton.setTitle("提交数据", forState: UIControlState.Normal)
        mSubmitDataButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        mSubmitDataButton.addTarget(self, action: #selector(ViewController.submitData), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mSubmitDataButton)
       
  
        self.view.addSubview(loadingIndicator)
        
        //编辑页设置
        //edit()
        
        //这个是打开订单页,需要的时候可以调用
        //WYSdk.getInstance().showOrderList(self)
        //这个是刷新订单状态的,在订单页才生效
        //WYSdk.getInstance().refreshOrderState()
        
        //myAppPay()
    }
    
    
    private func edit(){
        //打开二次编辑面页 默认是开的
        WYSdk.getInstance().isShowSelectDataViewController(true)
        
        //上啦加载更多,默认是关闭的
        WYSdk.getInstance().openLoadMore(true)
        WYSdk.getInstance().setWyLoadMoreDelegate {
            //WYSdk.getInstance().getTextBlock //创建文本
            //WYSdk.getInstance().getChapterBlock //创建章节
            
            ThreadUtils.threadOnAfterMain(1000, block: {
                let photoUrl1 = "http://img1.3lian.com/2015/w7/90/d/1.jpg"//1289 x 806
                let block = WYSdk.getInstance().getPhotoBlock("图片1", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: TimeUtils.getCurrentTime(), width: 1289, height: 806)
                
                let arr = NSMutableArray()
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                arr.addObject(block)
                //这个是必须调用的,可空,用来关闭loading和刷新数据
                WYSdk.getInstance().addLoadMoreData(arr)
            })
        }
    }
    
    //设置合作方的app支付 默认是false
    private func myAppPay(){
        WYSdk.getInstance().setMyAppPay(true)
        WYSdk.getInstance().setWyPayOrderDelegate { (orderId, price, randomStr) in
            //处理支付
            //合作方需要 orderId randomStr 来通知微印服务器
            //支付成功后,合作方服务器调微印服务器更新支付结果,文档在联调时索取
        }
    }
    
    private func addData() {
        //图片素材 必须是网络路径 宽高也是必要的
        let frontCoverUrl = "http://img1.3lian.com/2015/w7/98/d/22.jpg"//1210 x 681
        let flyleafHeadUrl = "http://img21.mtime.cn/mg/2011/05/18/161045.63077415.jpg"//251 x 251
        let backCoverUrl = "http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"//1358 x 765
        
        let photoUrl1 = "http://img1.3lian.com/2015/w7/90/d/1.jpg"//1289 x 806
        let photoUrl2 = "http://img2.3lian.com/img2007/23/08/025.jpg"//1001 x 751
        let photoUrl3 = "http://img1.goepe.com/201303/1362711681_6600.jpg"//988 x 738
        let photoUrl4 = "http://pic1.ooopic.com/00/87/39/27b1OOOPICf7.jpg"//813 x 592
        let photoUrl5 = "http://www.ctps.cn/PhotoNet/Profiles2011/20110503/20115302844162622467.jpg"//1208 x 806
        let photoUrl6 = "http://img2.3lian.com/2014/f2/110/d/57.jpg"//626 x 468
        
        //拍摄时间,由于是网络图片就自定义了一个时间
        let originalTime = TimeUtils.getCurrentTime()
        
        WYSdk.getInstance().setFrontCover("封面也就是书名", subTitle: "封面副标题", url: frontCoverUrl, lowPixelUrl: frontCoverUrl, originalTime: originalTime, width: 1210, height: 681)
        WYSdk.getInstance().setFlyleaf("头像", url: flyleafHeadUrl, lowPixelUrl: flyleafHeadUrl, originalTime: originalTime, width: 251, height: 251)
        WYSdk.getInstance().setPreface("这是序言")
        WYSdk.getInstance().setCopyright("这是作者名称", bookName: "这个是书名")
        WYSdk.getInstance().setBackCover(backCoverUrl, lowPixelUrl: backCoverUrl, originalTime: originalTime, width: 1358, height: 765)
        
        WYSdk.getInstance().addPhotoBlock("图片1", url: photoUrl1, lowPixelUrl: photoUrl1, originalTime: originalTime, width: 1289, height: 806)
        WYSdk.getInstance().addTextBlock("这是一段大文本1哦,我没跟在章节后面的哦")
        WYSdk.getInstance().addPhotoBlock("这个是照片2的描述哦,我也没跟在章节后面呢", url: photoUrl2, lowPixelUrl: photoUrl2, originalTime: originalTime, width: 1001, height: 751)
        
        WYSdk.getInstance().addChapterBlock("我是一个章节占一页哦", des: "我是章节的描述好吧")
        WYSdk.getInstance().addPhotoBlock("这个是照片3的描述哦,我也跟在章节后面呢", url: photoUrl3, lowPixelUrl: photoUrl3, originalTime: originalTime, width: 988, height: 738)
        WYSdk.getInstance().addPhotoBlock("这个是照片4的描述哦,我也跟在章节后面呢", url: photoUrl4, lowPixelUrl: photoUrl4, originalTime: originalTime, width: 813, height: 592)
        WYSdk.getInstance().addTextBlock("我是一个跟章节后面的文本2")
        
        WYSdk.getInstance().addChapterBlock("我是章节2", des: "我是章节的描述好吧")
        WYSdk.getInstance().addPhotoBlock("", url: photoUrl5, lowPixelUrl: photoUrl5, originalTime: originalTime, width: 1208, height: 806)
        WYSdk.getInstance().addPhotoBlock("这个是照片6的描述哦,我也跟在章节后面呢", url: photoUrl6, lowPixelUrl: photoUrl6, originalTime: originalTime, width: 626, height: 468)
        WYSdk.getInstance().addTextBlock("我是跟章节2后面的文本哦")
    }
    
    private func postData() {
        WYSdk.getInstance().postPrintData(self, start: { 
            
            self.loadingIndicator.start()
            
            }, success: { (result) in
                
                self.loadingIndicator.stop()
                
            }) { (msg) in
                
                self.loadingIndicator.stop()
                
        }
    }
    
    func submitData(){
        addData()
        postData()
    }
}