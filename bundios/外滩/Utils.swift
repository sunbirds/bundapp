//
//  utils.swift
//  外滩
//
//  Created by 彭然 on 15/11/9.
//  Copyright © 2015年 外滩画报. All rights reserved.
//

class Utils {
    static func fav(shareTitle: String,shareImage: String, shareLink: String,view: UIViewController,del: UMSocialUIDelegate) {
        
        let imageURL =  NSURL(string: shareImage)
        let imageData = NSData(contentsOfURL: imageURL!)
        let image = UIImage(data: imageData!)
        
        UMSocialData.defaultData().extConfig.wechatSessionData.url = shareLink
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = shareLink
        
        var sharingItems = [AnyObject]()
        sharingItems.append(UMShareToWechatSession)
        sharingItems.append(UMShareToWechatTimeline)
        sharingItems.append(UMShareToSina)
        UMSocialSnsService.presentSnsIconSheetView(view, appKey: "549a6067fd98c588990003ca", shareText: shareTitle, shareImage: image, shareToSnsNames:sharingItems , delegate: del)
    }
}

