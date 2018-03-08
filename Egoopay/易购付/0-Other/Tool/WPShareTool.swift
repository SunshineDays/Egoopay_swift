//
//  WPShareTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShareTool: NSObject {
    
    class func shareTitleArray() -> NSArray {
        let title_array = NSMutableArray()
        if OpenShare.isWeixinInstalled() {
            title_array.addObjects(from: ["微信好友", "微信朋友圈"])
        }
        if OpenShare.isQQInstalled() {
            title_array.addObjects(from: ["QQ好友", "QQ空间"])
        }
        title_array.addObjects(from: ["Safari中打开", "复制链接"])
        return title_array
    }
    
    class func shareImageArray() -> NSArray {
        let image_array = NSMutableArray()
        if OpenShare.isWeixinInstalled() {
            image_array.addObjects(from: [#imageLiteral(resourceName: "share_wechat"), #imageLiteral(resourceName: "share_weixin")])
        }
        if OpenShare.isQQInstalled() {
            image_array.addObjects(from: [#imageLiteral(resourceName: "share_qq"), #imageLiteral(resourceName: "share_qqzone")])
        }
        image_array.addObjects(from: [#imageLiteral(resourceName: "share_safari"), #imageLiteral(resourceName: "share_copyurl")])
        return image_array
    }
    
    class func shareToApp(model : WPShareModel) {
        let shareView = WPShareView()
        UIApplication.shared.keyWindow?.addSubview(shareView)
        shareView.shareToApp = {(shareTitle) -> Void in
            let shareArray: NSArray = ["微信好友", "微信朋友圈", "QQ好友", "QQ空间", "Safari中打开", "复制链接"]
            for i in 0 ..< self.shareTitleArray().count {
                if shareTitle as? String == shareArray[i] as? String {
                    switch i {
                    case 0:
                        shareToWeChatFriend(model: model)
                    case 1:
                        shareToWeChatCircle(model: model)
                    case 2:
                        shareToQQtFriend(model: model)
                    case 3:
                        shareToQQQzone(model: model)
                    case 4:
                        shareToSafari(model: model)
                    case 5:
                        shareToCopyUrl(model: model)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    /**  初始化分享信息 */
    class func shareMessage(model: WPShareModel) -> OSMessage {
        let message = OSMessage()
        message.title = model.title
        message.desc = model.share_despt
        message.image = UIImagePNGRepresentation(#imageLiteral(resourceName: "share_appIcon"))
        message.link = model.webpageUrl
        return message
    }
    
    class func shareToWeChatFriend(model: WPShareModel) {
        let message = self.shareMessage(model: model)
        OpenShare.share(toWeixinSession: message, success: { (success) in
            
        }) { (failure, error) in
            
        }
    }
    
    class func shareToWeChatCircle(model: WPShareModel) {
        let message = self.shareMessage(model: model)
        OpenShare.share(toWeixinTimeline: message, success: { (success) in
            
        }) { (failure, error) in
            
        }
    }
    
    class func shareToQQtFriend(model: WPShareModel) {
        let message = self.shareMessage(model: model)
        OpenShare.share(toQQFriends: message, success: { (success) in
            
        }) { (failure, error) in
            
        }
    }
    
    class func shareToQQQzone(model: WPShareModel) {
        let message = self.shareMessage(model: model)
        OpenShare.share(toQQZone: message, success: { (success) in
            
        }) { (failure, error) in
            
        }
    }
    
    class func shareToSafari(model: WPShareModel) {
        UIApplication.shared.open(URL.init(string: model.webpageUrl)!, options: ["" : ""], completionHandler: nil)
    }
    
    class func shareToCopyUrl(model: WPShareModel) {
        let pastedboard = UIPasteboard.general
        pastedboard.string = model.webpageUrl
        WPProgressHUD.showInfor(status: "已复制到剪切板")
    }
    
}
