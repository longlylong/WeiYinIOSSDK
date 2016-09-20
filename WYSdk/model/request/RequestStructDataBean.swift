//
//  RequestStructDataBean.swift
//  WYSdk
//
//  Created by weiyin on 16/4/6.
//  Copyright © 2016年 weiyin. All rights reserved.
//

import Foundation

public class RequestStructDataBean : NSObject {
    
    static let TYPE_PHOTO = 1
    static let TYPE_TEXT = 2
    static let TYPE_CHAPTER = 3
    
    func toJson() -> [String:AnyObject] {
        return[
            "identity":identity,
            "bookType":bookType,
            "unionId":unionId,
            "structData":structData.toJson()
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
                "cover":cover.toJson(),
                "flyleaf":flyleaf.toJson(),
                "preface":preface.toJson(),
                "dataBlocks":attrB,
                "copyright":copyright.toJson(),
                "backCover":backCover.toJson()
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
                "title":title,
                "subTitle":subTitle,
                "coverImgs":attrR
            ]
        }
    }
    
    class Flyleaf {
        var nick = ""
        var headImg = Resource()
        
        func toJson() -> [String:AnyObject] {
            return[
                "nick":nick,
                "headImg":headImg.toJson()
            ]
        }
    }
    
    class Preface {
        var text = ""
        
        func toJson() -> [String:AnyObject] {
            return[
                "text":text
            ]
        }
    }
    
    class Chapter {
        var desc = ""//章节描述
        var title = ""//章节名
        
        func toJson() -> [String:AnyObject] {
            return[
                "desc":desc,
                "title":title
            ]
        }
    }
    
    class Copyright {
        var author = ""//作者
        var bookName = ""//书名
        
        func toJson() -> [String:AnyObject] {
            return[
                "author":author,
                "bookName":bookName
            ]
        }
    }
    
    public class Block : NSObject{
        
        var blockType = 0
        
        var isSelected = false
        
        var text = ""//纯文本
        var resource = Resource()//图片
        var chapter = Chapter()//章节
        
        func toJson() -> [String:AnyObject] {
            return[
                "text":text,
                "resource":resource.url.isEmpty ? "" : resource.toJson(),
                "chapter":chapter.title.isEmpty ? "" : chapter.toJson()
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
                "desc":desc,
                "url":url,
                "lowPixelUrl":lowPixelUrl,
                "originaltime":originaltime,
                "height":height,
                "width":width
            ]
        }
    }
}
