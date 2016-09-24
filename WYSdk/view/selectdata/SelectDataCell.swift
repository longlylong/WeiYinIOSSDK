//
//  SelectDataCell.swift
//  wysdkdemo
//
//  Created by weiyin on 16/6/20.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
import Kingfisher

class SelectDataCell: UICollectionViewCell {
    
    static func getReuseIdentifier() -> String{
        return "SelectDataCell"
    }
    
    fileprivate var mCellView = UIView()                //布局View
    fileprivate var mPhotoImageView = UIImageView()     //显示照片的imageView
    fileprivate var mWaringImageView = UIImageView()
    fileprivate var mHasTextIcon = UIImageView()
    
    fileprivate var mText = UILabel()
    
    fileprivate var mSelectView = UIView()              //选中View灰色背景
    fileprivate var mSelectImageView = UIImageView()    //选中态ImageView
    
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
    
    fileprivate func initPhotosSelectCell(){
        let itemSize = (UIUtils.getScreenWidth() - 2) * 0.333
        
        mCellView = UIView(frame: CGRect(x: 0, y: 0, width: itemSize, height: itemSize))
        mSelectView = UIView(frame: CGRect(x: 0, y: 0, width: itemSize, height: itemSize))
        
        mWaringImageView = UIImageView(frame: CGRect(x: itemSize - 28, y: 8, width: 20, height: 20))
        mWaringImageView.image = UIImage(named: "icon_tip")
        
        mPhotoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: itemSize, height: itemSize))
        mHasTextIcon = UIImageView(frame: CGRect(x: 0, y: itemSize - 22 , width: 22, height: 22))
        mHasTextIcon.image = UIImage(named: "icon_show_text")
    
        mPhotoImageView.addSubview(mHasTextIcon)
        mPhotoImageView.addSubview(mWaringImageView)

        mText = UILabel(frame: CGRect(x: 10, y: 10, width: itemSize - 20 , height: itemSize - 20))
        mText.font = UIFont.systemFont(ofSize: UIUtils.BOBY_FONT_SIZE)
        mText.textColor = UIUtils.getTextWhiteColor()
        mText.numberOfLines = 5
        
        mSelectImageView = UIImageView(frame: CGRect(x: (itemSize - 20) / 2, y: (itemSize - 20) / 2, width: 20, height: 20))
        mSelectImageView.image = UIImage(named: "icon_check_white")
        mSelectView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        mSelectView.layer.zPosition = 1000
        mSelectView.isHidden = true
        
        mCellView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        mSelectView.addSubview(mSelectImageView)
        
        mCellView.addSubview(mPhotoImageView)
        mCellView.addSubview(mSelectView)
        mCellView.addSubview(mText)
        
        self.addSubview(mCellView)
    }
    
    func showData(_ block:RequestStructDataBean.Block){
       
        if block.blockType == RequestStructDataBean.TYPE_TEXT {
            
            mText.text = block.text
            mText.isHidden = false
            mPhotoImageView.isHidden = true
            
        }else{
            mPhotoImageView.isHidden = false
            mText.isHidden = true
            
            mWaringImageView.isHidden = !showWaring(block.resource.width, height: block.resource.height)
            
            if block.resource.desc.isEmpty {
                mHasTextIcon.isHidden = true
            }else{
                mHasTextIcon.isHidden = false
            }
            mPhotoImageView.kf_setImage(with: URL(string: block.resource.url)!)
        }
    
        mSelectView.isHidden = !block.isSelected
    }
    
    fileprivate func showWaring(_ width:Int,height:Int)-> Bool{
        let scale =  (width > height ? width : height) / (width > height ? height : width)
        return width < 600 || height < 600 || scale > 2
    }
    
    func isSelected(_ isSelected:Bool)  {
        mSelectView.isHidden = !isSelected
    }
}
