//
//  SelectDataCell.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
//import Kingfisher

class SelectDataCell: UICollectionViewCell {
    
    static func getReuseIdentifier() -> String{
        return "SelectDataCell"
    }
    
    private var mCellView = UIView()                //布局View
    private var mPhotoImageView = UIImageView()     //显示照片的imageView
    private var mImageText = UILabel()
    
    private var mText = UILabel()
    
    private var mSelectView = UIView()              //选中View灰色背景
    private var mSelectImageView = UIImageView()    //选中态ImageView
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPhotosSelectCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initPhotosSelectCell(){
        let itemSize = (UIUtils.getScreenWidth() - 2) * 0.333
        
        mCellView = UIView(frame: CGRectMake(0, 0, itemSize, itemSize))
        mSelectView = UIView(frame: CGRectMake(0, 0, itemSize, itemSize))
        
        mPhotoImageView = UIImageView(frame: CGRectMake(0, 0, itemSize, itemSize))
        mImageText = UILabel(frame: CGRectMake(0, itemSize - 20 , itemSize, 20))
        mImageText.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mImageText.textColor = UIUtils.getTextWhiteColor()
        mImageText.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        mPhotoImageView.addSubview(mImageText)

        mText = UILabel(frame: CGRectMake(10, 10, itemSize - 20 , itemSize - 20))
        mText.font = UIFont.systemFontOfSize(UIUtils.BOBY_FONT_SIZE)
        mText.textColor = UIUtils.getTextWhiteColor()
        mText.numberOfLines = 5
        
        
        mSelectImageView = UIImageView(frame: CGRectMake((itemSize - 20) / 2, (itemSize - 20) / 2, 20, 20))
        mSelectImageView.image = UIImage(named: "icon_check_white")
        mSelectView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        mSelectView.layer.zPosition = 1000
        mSelectView.hidden = true
        
        mCellView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        mSelectView.addSubview(mSelectImageView)
        mCellView.addSubview(mPhotoImageView)
        mCellView.addSubview(mSelectView)
        mCellView.addSubview(mText)
        
        self.addSubview(mCellView)
    }
    
    func showData(block:RequestStructDataBean.Block){
       
        if block.blockType == RequestStructDataBean.TYPE_TEXT {
            
            mText.text = block.text
            mText.hidden = false
            mPhotoImageView.hidden = true
            
        }else{
            mPhotoImageView.hidden = false
            mText.hidden = true
            
            mImageText.text = block.resource.desc
            if block.resource.desc.isEmpty {
                mImageText.hidden = true
            }else{
                mImageText.hidden = false
            }
            mPhotoImageView.kf_setImageWithURL(NSURL(string: block.resource.url)!)
        }
    
        mSelectView.hidden = !block.isSelected
    }
    
    func isSelected(isSelected:Bool)  {
        mSelectView.hidden = !isSelected
    }
}