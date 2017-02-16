//
//  SelectDataViewController.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

class SelectDataViewController  : BaseUIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WYEditTextDelegate,UIScrollViewDelegate,WeiYinDownSheetDelegate,WeiYinFootDelegate{
    
    fileprivate var mCollectionView :UICollectionView!
    fileprivate var mData = NSMutableDictionary()
    fileprivate var mKeys = Array<String>()
    fileprivate var mHead = Array<Block>()
    
    fileprivate var loadingIndicator = LoadingView()
    fileprivate var VC : UIViewController?
    
    fileprivate var mSheet = WeiYinDownSheet()
    
    fileprivate var isLoadMore = false
    
    fileprivate var mLastVisibleIndex : IndexPath?
    fileprivate var mLastLongPressIndex : IndexPath?
    fileprivate var mLastLongPressBlock : Block?
    
    var mBookType = 0 // WYsdk.Print_Book
    
    
    static func launch(_ vc:UIViewController,bookType:Int){
        let selectDataVC = SelectDataViewController()
        selectDataVC.VC = vc
        selectDataVC.mBookType = bookType
        let nv = UINavigationController(rootViewController: selectDataVC)
        vc.present(nv, animated: true, completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0.5 {
            if WYSdk.getInstance().isLoadMore() {
                if (mLastVisibleIndex as NSIndexPath?)?.section == mHead.count - 1 && !isLoadMore{
                    let arr = mData.value(forKey: mKeys[(mLastVisibleIndex! as NSIndexPath).section])
                    if (mLastVisibleIndex as NSIndexPath?)?.row >= (arr! as AnyObject).count - 1 {
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
        
        setNavTextButton(leftText:"选择照片",rightText:"预览排版")
        
        let itemSize = (UIUtils.getScreenWidth() - 2) * 0.333
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: UIUtils.getScreenWidth(), height: 40)       //设置CollectionView 头的大小
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        
        let screenWidth = UIUtils.getScreenWidth()
        let screenHeight = UIUtils.getScreenHeight()
        
        if SpUtils.getTipsFlag(){
            
            let tipsLayout = UIView(frame: CGRect(x:0,y:60, width:screenWidth,height:40))
            tipsLayout.backgroundColor = UIUtils.getTipsGray()
            
            let tipText = UILabel(frame: CGRect(x:0,y:0, width:screenWidth - 50,height:40))
            tipText.text = "长按照片可编辑或添加文本"
            tipText.font = UIFont.systemFont(ofSize: 15)
            tipText.textAlignment = NSTextAlignment.center
            
            let tipCancel = UIButton(frame: CGRect(x:tipText.frame.width,y:2, width: 40,height:40))
            tipCancel.setImage(UIImage(named:"icon_cancel"), for: UIControlState())
            tipCancel.addTarget(self, action: #selector(SelectDataViewController.closeTipsLayout), for: UIControlEvents.touchUpInside)
            
            tipsLayout.addSubview(tipText)
            tipsLayout.addSubview(tipCancel)
            self.view.addSubview(tipsLayout)
            mCollectionView = UICollectionView(frame:CGRect(x: 0,y: 100, width: screenWidth, height: screenHeight), collectionViewLayout: flowLayout)
            
            SpUtils.saveTipsFlag(flag: false)
        }else{
            mCollectionView = UICollectionView(frame:CGRect(x: 0,y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: flowLayout)
        }
        
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.backgroundColor = UIColor.white
        mCollectionView.register(SelectDataCell.self, forCellWithReuseIdentifier: SelectDataCell.getReuseIdentifier())
        mCollectionView.register(SelectSection.self,forSupplementaryViewOfKind: UICollectionElementKindSectionHeader.self,withReuseIdentifier: SelectSection.getReuseIdentifier())
        
        mCollectionView.register(SelectFoot.self,forSupplementaryViewOfKind: UICollectionElementKindSectionFooter.self,withReuseIdentifier: SelectFoot.getReuseIdentifier())
        
        mCollectionView.alwaysBounceVertical = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SelectDataViewController.handleCollectViewLongPress(_:)))
        mCollectionView.addGestureRecognizer(longPress)

        self.view.addSubview(mCollectionView)
        self.view.addSubview(loadingIndicator)
    }
    
    override func initData() {
        mData = NSMutableDictionary()
        mKeys = Array<String>()
        mHead = Array<Block>()
        
        let structData = WYSdk.getInstance().getStructData()
        var lastKey = ""
        
        for x in 0...structData.structData.dataBlocks.count - 1  {
            let block = structData.structData.dataBlocks[x]
            if x == 0{
                var arr = Array<Block>()
                lastKey = "\(x)"
                
                if block.blockType == RequestStructDataBean.TYPE_CHAPTER{
                    mHead.append(block)
                }else{
                    let b = Block()
                    mHead.append(b)
                    arr.append(block)
                }
                
                mData.setObject(arr, forKey: lastKey as NSCopying)
                mKeys.append(lastKey)
            }else{
               
                if block.blockType == RequestStructDataBean.TYPE_CHAPTER{
                    lastKey = "\(x)"
                    mHead.append(block)
                    mKeys.append(lastKey)
                }else{
                    var arr = mData.value(forKey: lastKey) as? Array<Block>
                    if arr == nil {
                        arr = Array<Block>()
                    }
                    arr!.append(block)
                    mData.setObject(arr!, forKey: lastKey as NSCopying)
                }
            }
        }
    }
    
    func closeTipsLayout(){
        let screenWidth = UIUtils.getScreenWidth()
        let screenHeight = UIUtils.getScreenHeight()
        mCollectionView.frame = CGRect(x: 0,y: 60, width: screenWidth, height: screenHeight)
        SpUtils.saveTipsFlag(flag: false)
    }
    
    func addLoadMoreData(_ blockList:NSMutableArray?) {
        loadingIndicator.stop()
        isLoadMore = false
        
        if blockList != nil {
            initData()
            mCollectionView.reloadData()
        }
    }
    
    func handleCollectViewLongPress(_ gesture:UILongPressGestureRecognizer){
        let point = gesture.location(in: mCollectionView)
        let indexPath = mCollectionView.indexPathForItem(at: point)
        if indexPath != nil {
            let key = mKeys[(indexPath! as NSIndexPath).section]
            let arr = mData.value(forKey: key) as! Array<Block>
            let block = arr[(indexPath! as NSIndexPath).row]
            
            block.isSelected = true
            
            var text = ""
            if block.blockType == RequestStructDataBean.TYPE_TEXT {
                text = block.text
            }else if block.blockType == RequestStructDataBean.TYPE_PHOTO{
                text = block.resource.desc
            }
            
            mLastLongPressBlock = block
            mLastLongPressIndex = indexPath
            
            mCollectionView.reloadItems(at: [indexPath!])
            EditTextViewController.launch(self, text: text, wyEditTextDelegate: self)
        }
        
    }
    
    func textViewDidChange(_ text:String){
        if mLastLongPressBlock!.blockType == RequestStructDataBean.TYPE_TEXT {
             mLastLongPressBlock!.text = text
        }else if mLastLongPressBlock!.blockType == RequestStructDataBean.TYPE_PHOTO{
             mLastLongPressBlock!.resource.desc = text
        }
        mCollectionView.reloadItems(at: [mLastLongPressIndex!])
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
        var selectedArr = Array<Block>()
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
                
                self.dismiss(animated: true, completion: nil)
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
        data.add(shopcart)
        
        let myorder = WeiYinDownSheetModel()
        myorder.text = "我的订单"
        data.add(myorder)
        
        let about = WeiYinDownSheetModel()
        about.text = "实物介绍"
        data.add(about)
        
        let question = WeiYinDownSheetModel()
        question.text = "常见问题"
        data.add(question)
        
        mSheet.initWYDownSheet(data)
        mSheet.ShowInView(self)
    }
    
    //MARK: 一些点击回调
    func onSheetSelectIndex(_ index: Int) {
        if index == 0 {
            WYSdk.getInstance().showShopCart(self)
        }else if index == 1{
            WYSdk.getInstance().showOrderList(self)
        }else if index == 2{
            WYSdk.getInstance().showPaper(self)
        }else if index == 3 {
            WYSdk.getInstance().showQuestion(self)
        }
    }
    
    func onSheetCancel() {
        WYSdk.getInstance().resetStructDataBean()
        self.dismiss(animated: true, completion: nil)
    }
    
    func onFootClick() {
        if WYSdk.getInstance().isLoadMore() {
            
            isLoadMore = true
            loadingIndicator.start()
            WYSdk.getInstance().getWyLoadMoreDelegate()?()
    
        }
    }
    
    //MARK: collectionView 的生命周期
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = mKeys[section]
        let arr = mData.value(forKey: key) as? Array<Block>
        return arr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var view  = collectionView.dequeueReusableCell(withReuseIdentifier: SelectDataCell.getReuseIdentifier(), for: indexPath) as? SelectDataCell
        if view == nil {
            view = SelectDataCell()
        }
        var arr = mData.value(forKey: mKeys[(indexPath as NSIndexPath).section]) as! Array<Block>
        
        view!.showData(arr[(indexPath as NSIndexPath).row])
        
        mLastVisibleIndex = indexPath
        
        return view!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            var view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader.self, withReuseIdentifier: SelectSection.getReuseIdentifier(), for: indexPath) as? SelectSection
            if view == nil {
                view = SelectSection()
            }
            
            let head = mHead[(indexPath as NSIndexPath).section]
            view!.setHeaderData(head, indexPath: indexPath)
            view!.mAllSelectBtn.addTarget(self, action: #selector(SelectDataViewController.allPhotosCheckClick(_:)), for: UIControlEvents.touchUpInside)
            return view!
        }else {
            var view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter.self, withReuseIdentifier: SelectFoot.getReuseIdentifier(), for: indexPath) as? SelectFoot
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let itemSize = (UIUtils.getScreenWidth() - 2)*0.333
        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectDataCell
        
        var arr = mData.value(forKey: mKeys[(indexPath as NSIndexPath).section]) as! Array<Block>
        
        let block = arr[(indexPath as NSIndexPath).row]
        block.isSelected = !block.isSelected
        
        cell.isSelected(block.isSelected)
    }
    
    func allPhotosCheckClick(_ sender:UIButton){
        let section = sender.tag
        let arr = mData.value(forKey: mKeys[section]) as! Array<Block>
        let head = mHead[section]
        head.isSelected = !head.isSelected
        for block in arr {
            block.isSelected = head.isSelected
        }
        
        mCollectionView.reloadSections(IndexSet(integer: section))
    }
    
    //MARK: vc 的生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
