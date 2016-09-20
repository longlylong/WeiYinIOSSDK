//
//  SelectDataViewController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
class SelectDataViewController  : BaseUIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WYEditTextDelegate,UIScrollViewDelegate,WeiYinDownSheetDelegate,WeiYinFootDelegate{
    
    private var mCollectionView :UICollectionView!
    private var mData = NSMutableDictionary()
    private var mKeys = Array<String>()
    private var mHead = Array<RequestStructDataBean.Block>()
    
    private var loadingIndicator = LoadingView()
    private var VC : UIViewController?
    
    private var mSheet = WeiYinDownSheet()
    
    private var isLoadMore = false
    
    private var mLastVisibleIndex : NSIndexPath?
    private var mLastLongPressIndex : NSIndexPath?
    private var mLastLongPressBlock : RequestStructDataBean.Block?
    
    var mBookType = 0 // WYsdk.Print_Book
    
    
    static func launch(vc:UIViewController,bookType:Int){
        let selectDataVC = SelectDataViewController()
        selectDataVC.VC = vc
        selectDataVC.mBookType = bookType
        let nv = UINavigationController(rootViewController: selectDataVC)
        vc.presentViewController(nv, animated: true, completion: nil)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0.5 {
            if WYSdk.getInstance().isLoadMore() {
                if mLastVisibleIndex?.section == mHead.count - 1 && !isLoadMore{
                    let arr = mData.valueForKey(mKeys[mLastVisibleIndex!.section])
                    if mLastVisibleIndex?.row >= arr!.count - 1 {
                        isLoadMore = true
                        loadingIndicator.start()
                        WYSdk.getInstance().getWyLoadMoreDelegate()?()
                    }
                }
            }
        }
    }
    
    override func initUI() {
        
        WYSdk.getInstance().setSelectDataPage(self)
        
        setNavTextButton()
        
        let itemSize = (UIUtils.getScreenWidth() - 2) * 0.333
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSizeMake(UIUtils.getScreenWidth(), 40)       //设置CollectionView 头的大小
        flowLayout.itemSize = CGSizeMake(itemSize, itemSize)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        mCollectionView = UICollectionView(frame:CGRectMake(0,0, UIUtils.getScreenWidth(), UIUtils.getScreenHeight()), collectionViewLayout: flowLayout)
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.backgroundColor = UIColor.whiteColor()
        mCollectionView.registerClass(SelectDataCell.self, forCellWithReuseIdentifier: SelectDataCell.getReuseIdentifier())
        mCollectionView.registerClass(SelectSection.self,forSupplementaryViewOfKind: UICollectionElementKindSectionHeader.self,withReuseIdentifier: SelectSection.getReuseIdentifier())
        
        mCollectionView.registerClass(SelectFoot.self,forSupplementaryViewOfKind: UICollectionElementKindSectionFooter.self,withReuseIdentifier: SelectFoot.getReuseIdentifier())
        
        mCollectionView.alwaysBounceVertical = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SelectDataViewController.handleCollectViewLongPress(_:)))
        mCollectionView.addGestureRecognizer(longPress)

        self.view.addSubview(mCollectionView)
        self.view.addSubview(loadingIndicator)
    }
    
    override func initData() {
        mData = NSMutableDictionary()
        mKeys = Array<String>()
        mHead = Array<RequestStructDataBean.Block>()
        
        let structData = WYSdk.getInstance().getStructData()
        var lastKey = ""
        
        for x in 0...structData.structData.dataBlocks.count - 1  {
            let block = structData.structData.dataBlocks[x]
            if x == 0{
                var arr = Array<RequestStructDataBean.Block>()
                lastKey = "\(x)"
                
                if block.blockType == RequestStructDataBean.TYPE_CHAPTER{
                    mHead.append(block)
                }else{
                    let b = RequestStructDataBean.Block()
                    mHead.append(b)
                    arr.append(block)
                }
                
                mData.setObject(arr, forKey: lastKey)
                mKeys.append(lastKey)
            }else{
               
                if block.blockType == RequestStructDataBean.TYPE_CHAPTER{
                    lastKey = "\(x)"
                    mHead.append(block)
                    mKeys.append(lastKey)
                }else{
                    var arr = mData.valueForKey(lastKey) as? Array<RequestStructDataBean.Block>
                    if arr == nil {
                        arr = Array<RequestStructDataBean.Block>()
                    }
                    arr!.append(block)
                    mData.setObject(arr!, forKey: lastKey)
                }
            }
        }
    }
    
    func addLoadMoreData(blockList:NSMutableArray?) {
        loadingIndicator.stop()
        isLoadMore = false
        
        if blockList != nil {
            initData()
            mCollectionView.reloadData()
        }
    }
    
    func handleCollectViewLongPress(gesture:UILongPressGestureRecognizer){
        let point = gesture.locationInView(mCollectionView)
        let indexPath = mCollectionView.indexPathForItemAtPoint(point)
        if indexPath != nil {
            let key = mKeys[indexPath!.section]
            let arr = mData.valueForKey(key) as! Array<RequestStructDataBean.Block>
            let block = arr[indexPath!.row]
            
            block.isSelected = true
            
            var text = ""
            if block.blockType == RequestStructDataBean.TYPE_TEXT {
                text = block.text
            }else if block.blockType == RequestStructDataBean.TYPE_PHOTO{
                text = block.resource.desc
            }
            
            mLastLongPressBlock = block
            mLastLongPressIndex = indexPath
            
            mCollectionView.reloadItemsAtIndexPaths([indexPath!])
            EditTextViewController.launch(self, text: text, wyEditTextDelegate: self)
        }
        
    }
    
    func textViewDidChange(text:String){
        if mLastLongPressBlock!.blockType == RequestStructDataBean.TYPE_TEXT {
             mLastLongPressBlock!.text = text
        }else if mLastLongPressBlock!.blockType == RequestStructDataBean.TYPE_PHOTO{
             mLastLongPressBlock!.resource.desc = text
        }
        mCollectionView.reloadItemsAtIndexPaths([mLastLongPressIndex!])
    }
    
    func handleRightButton(){
        loadingIndicator.start()
        
        let structData = WYSdk.getInstance().getStructData()
        var count = 0
        
        let size = structData.structData.dataBlocks.count
        
        for x in 0...size - 1  {
            let block = structData.structData.dataBlocks[x]
            if block.isSelected {
                count = count + 1
            }
        }
        if count == 0 {
            loadingIndicator.stop()
            return
        }
        var selectedArr = Array<RequestStructDataBean.Block>()
        for x in 0...size - 1 {
            
            let block = structData.structData.dataBlocks[x]
            
            if block.blockType == RequestStructDataBean.TYPE_CHAPTER && x < size - 2 {
                let nextBlock = structData.structData.dataBlocks[x+1]
                if nextBlock.isSelected {
                    selectedArr.append(block)
                }
            }
            
            if block.isSelected && block.blockType != RequestStructDataBean.TYPE_CHAPTER{
                selectedArr.append(block)
            }
        }
        structData.structData.dataBlocks = selectedArr
        
        
        WYSdk.getInstance().requestPrint(VC!,bookType: mBookType,failedClear: false,start: {
            
            }, success: { (result) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                self.loadingIndicator.stop()
                
            }) { (msg) in
                self.loadingIndicator.stop()
                DialogUtils.showCustomNoCancelDialog(nil, tag: 0, msg: msg, otherBtnTitle: "知道了", title: "提醒")
                
        }
    }
    
    func handleLeftButton(){
        
        if self.mSheet.isShowing {
            self.mSheet.close()
            return
        }
        
        self.mSheet = WeiYinDownSheet()
        self.mSheet.delegate = self
       
        let data = NSMutableArray()
        
        let shopcart = WeiYinDownSheetModel()
        shopcart.text = "购物车"
        data.addObject(shopcart)
        
        let myorder = WeiYinDownSheetModel()
        myorder.text = "我的订单"
        data.addObject(myorder)
        
        let about = WeiYinDownSheetModel()
        about.text = "实物介绍"
        data.addObject(about)
        
        mSheet.initWYDownSheet(data)
        mSheet.ShowInView(self)
    }
    
    //MARK: 一些点击回调
    func onSheetSelectIndex(index: Int) {
        if index == 0 {
            WYSdk.getInstance().showShopCart(self)
        }else if index == 1{
            WYSdk.getInstance().showOrderList(self)
        }else if index == 2{
            WYSdk.getInstance().showPaper(self)
        }
    }
    
    func onSheetCancel() {
        WYSdk.getInstance().resetStructDataBean()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onFootClick() {
        if WYSdk.getInstance().isLoadMore() {
            
            isLoadMore = true
            loadingIndicator.start()
            WYSdk.getInstance().getWyLoadMoreDelegate()?()
    
        }
    }
    
    //MARK: collectionView 的生命周期
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return mData.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = mKeys[section]
        let arr = mData.valueForKey(key) as? Array<RequestStructDataBean.Block>
        return arr!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var view  = collectionView.dequeueReusableCellWithReuseIdentifier(SelectDataCell.getReuseIdentifier(), forIndexPath: indexPath) as? SelectDataCell
        if view == nil {
            view = SelectDataCell()
        }
        var arr = mData.valueForKey(mKeys[indexPath.section]) as! Array<RequestStructDataBean.Block>
        
        view!.showData(arr[indexPath.row])
        
        mLastVisibleIndex = indexPath
        
        return view!
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            var view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader.self, withReuseIdentifier: SelectSection.getReuseIdentifier(), forIndexPath: indexPath) as? SelectSection
            if view == nil {
                view = SelectSection()
            }
            
            let head = mHead[indexPath.section]
            view!.setHeaderData(head, indexPath: indexPath)
            view!.mAllSelectBtn.addTarget(self, action: #selector(SelectDataViewController.allPhotosCheckClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return view!
        }else {
            var view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter.self, withReuseIdentifier: SelectFoot.getReuseIdentifier(), forIndexPath: indexPath) as? SelectFoot
            if view == nil {
                view = SelectFoot()
            }
            
            view?.delegate = self
            
            return view!
        }
    }
    
    /*********
     根据照片的宽高比计算每个cell的高度
     ***********/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let itemSize = (UIUtils.getScreenWidth() - 2)*0.333
        return CGSizeMake(itemSize, itemSize)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if WYSdk.getInstance().isLoadMore() {
            if section == mData.count - 1 {
                return SelectFoot().getHeight()
            }else{
                return CGSize(width: 0,height: 0)
            }
        }else{
            return CGSize(width: 0,height: 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectDataCell
        
        var arr = mData.valueForKey(mKeys[indexPath.section]) as! Array<RequestStructDataBean.Block>
        
        let block = arr[indexPath.row]
        block.isSelected = !block.isSelected
        
        cell.isSelected(block.isSelected)
    }
    
    func allPhotosCheckClick(sender:UIButton){
        let section = sender.tag
        let arr = mData.valueForKey(mKeys[section]) as! Array<RequestStructDataBean.Block>
        let head = mHead[section]
        head.isSelected = !head.isSelected
        for block in arr {
            block.isSelected = head.isSelected
        }
        
        mCollectionView.reloadSections(NSIndexSet(index: section))
    }
    
    //MARK: vc 的生命周期
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
}
