//
//  RequestStructDataBean.swift
//  WYSdk
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

open class RequestStructDataBean : NSObject {
    
    static let TYPE_PHOTO = 1
    static let TYPE_TEXT = 2
    static let TYPE_CHAPTER = 3
    
    func toJson() -> [String:AnyObject] {
        return[
            "identity":identity as AnyObject,
            "bookType":bookType as AnyObject,
            "unionId":unionId as AnyObject,
            "structData":structData.toJson() as AnyObject
        ]
    }

    var identity = ""
    
    var bookType = 0 // WYsdk.Print_Book
    
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
        
        func toJson() -> [String:AnyObject] {
            
            var attrB = Array<[String : AnyObject]>()
            for b in dataBlocks{
                attrB.append(b.toJson())
            }
            
            return[
                "cover":cover.toJson() as AnyObject,
                "flyleaf":flyleaf.toJson() as AnyObject,
                "preface":preface.toJson() as AnyObject,
                "dataBlocks":attrB  as AnyObject,
                "copyright":copyright.toJson() as AnyObject,
                "backCover":backCover.toJson() as AnyObject
            ]
        }
    }
    
    class Cover {
        var title = ""
        var subTitle = ""
        var coverImgs = Array<Resource>()
        
        func toJson() -> [String:AnyObject] {
            
            var attrR = Array<[String : AnyObject]>()
            for r in coverImgs{
                attrR.append(r.toJson())
            }
            
            return[
                "title":title as AnyObject,
                "subTitle":subTitle as AnyObject,
                "coverImgs":attrR as AnyObject
            ]
        }
    }
    
    class Flyleaf {
        var nick = ""
        var headImg = Resource()
        
        func toJson() -> [String:AnyObject] {
            return[
                "nick":nick as AnyObject,
                "headImg":headImg.toJson() as AnyObject
            ]
        }
    }
    
    class Preface {
        var text = ""
        
        func toJson() -> [String:AnyObject] {
            return[
                "text":text as AnyObject
            ]
        }
    }
    
    class Chapter {
        var desc = ""//章节描述
        var title = ""//章节名
        
        func toJson() -> [String:AnyObject] {
            return[
                "desc":desc as AnyObject,
                "title":title as AnyObject
            ]
        }
    }
    
    class Copyright {
        var author = ""//作者
        var bookName = ""//书名
        
        func toJson() -> [String:AnyObject] {
            return[
                "author":author as AnyObject,
                "bookName":bookName as AnyObject
            ]
        }
    }
    
    open class Block : NSObject{
        
        var blockType = 0
        
        var isSelected = false
        
        var text = ""//纯文本
        var resource = Resource()//图片
        var chapter = Chapter()//章节
        
        func toJson() -> [String:AnyObject] {
            return[
                "text":text as AnyObject,
                "resource":resource.url.isEmpty ? "" as AnyObject : resource.toJson() as AnyObject,
                "chapter":chapter.title.isEmpty ? "" as AnyObject : chapter.toJson() as AnyObject
            ]
        }
    }
    
    class Resource {
        var desc = ""//资源描述
        var url = "" //资源地址
        var lowPixelUrl = "" //资源地址低精度
        var originaltime = 0 //拍摄时间
        var height = 0 //原图高
        var width = 0 //原图宽
        
        func toJson() -> [String:AnyObject] {
            return[
                "desc":desc as AnyObject,
                "url":url as AnyObject,
                "lowPixelUrl":lowPixelUrl as AnyObject,
                "originaltime":originaltime as AnyObject,
                "height":height as AnyObject,
                "width":width as AnyObject
            ]
        }
    }
}
