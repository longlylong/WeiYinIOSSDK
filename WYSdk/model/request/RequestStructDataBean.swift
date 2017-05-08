//
//  RequestStructDataBean.swift
//  WYSdk
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation
import HandyJSON

open class RequestStructDataBean : NSObject {
    
    static let TYPE_PHOTO = 1
    static let TYPE_TEXT = 2
    static let TYPE_CHAPTER = 3
    
    func toJson() -> [String:Any] {
        return[
            "identity":identity ,
            "bookType":bookType ,
            "bookMakeType":makeType ,
            "unionId":unionId ,
            "structData":structData.toJson() 
        ]
    }

    var identity = ""
    
    var bookType = 0 // WYsdk.BookType_Big
    
    var makeType = 0 //WYsdk.MakeType_Simple
    
    /**
     * 第一次提交不用 分批以后第二次提交要传这个
     */
    var unionId = 0
    
    var structData = StructData()
    
    class StructData {
        
        var cover = Cover()
        
        var flyleaf = Flyleaf()
        
        var preface = Preface()
        
        var dataBlocks = Array<Block>()
        
        var copyright = Copyright()
        
        var backCover = Cover()
        
        func toJson() -> [String:Any] {
            
            var attrB = Array<[String : Any]>()
            for b in dataBlocks{
                attrB.append(b.toJson())
            }
            
            return[
                "cover":cover.toJson() ,
                "flyleaf":flyleaf.toJson() ,
                "preface":preface.toJson() ,
                "dataBlocks":attrB  ,
                "copyright":copyright.toJson() ,
                "backCover":backCover.toJson() 
            ]
        }
    }
    
}

class Cover : HandyJSON{
    
    required init() {
        
    }
    
    var title = ""
    var subTitle = ""
    var coverImgs = Array<Resource>()
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
}

class Flyleaf : HandyJSON{
    
    required init() {
        
    }
    var nick = ""
    var headImg = Resource()
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
}

class Preface : HandyJSON{
    
    required init() {
        
    }
    var text = ""
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
}

class Chapter : HandyJSON{
    
    required init() {
        
    }
    var desc = ""//章节描述
    var title = ""//章节名
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
}

class Copyright : HandyJSON{
    
    required init() {
        
    }
    var author = ""//作者
    var bookName = ""//书名
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
}

open class Block : NSObject{
    
    var blockType = 0
    
    var isSelected = false
    
    var text = ""//纯文本
    var resource = Resource()//图片
    var chapter = Chapter()//章节
    
    func toJson() -> [String:Any] {
        return[
            "text":text ,
            "resource":resource.url.isEmpty ? ""  : resource.toJson() ,
            "chapter":chapter.title.isEmpty ? ""  : chapter.toJson() 
        ]
    }
}

class Resource : HandyJSON{
    
    required init() {
        
    }
    var desc = ""//资源描述
    var url = "" //资源地址
    var lowPixelUrl = "" //资源地址低精度
    var originaltime = 0 //拍摄时间
    var height = 0 //原图高
    var width = 0 //原图宽
    
    func toJson() -> [String:Any] {
        return self.toJSON()!
    }
}

