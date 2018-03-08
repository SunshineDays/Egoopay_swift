//
//  WPKeyChainTools.swift
//  Egoopay
//
//  Created by 易购付 on 2018/3/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

//let kUserPayPassword_Infor: String = "com.wintopay.ios.userpaypassword"

class WPKeyChainTools: NSObject {

//    class func keyChainSave(string: String, key: String) {
//        let tempDic = NSMutableDictionary()
//        tempDic.setObject(string, forKey: key as NSCopying)
//        self.save(service: kUserPayPassword_Infor, data: tempDic)
//    }
//    
//    class func keyChainRead(key: String) -> String {
//        let tempDic: NSMutableDictionary = self.load(service: kUserPayPassword_Infor) as! NSMutableDictionary
//        return tempDic.object(forKey: key) as! String
//    }
//    
//    class func keyChainDelete() {
//        self.delete(service: kUserPayPassword_Infor)
//    }
    
    class func getKeyChainQuery(service: String) -> NSMutableDictionary {
        let dic = [kSecClass : kSecClassGenericPassword,
                   kSecAttrService : service,
                   kSecAttrAccount : service,
                   kSecAttrAccessible : kSecAttrAccessibleAfterFirstUnlock] as [CFString : Any]
        return NSMutableDictionary.init(dictionary: dic)
    }
    
    class func save(service: String, data: NSMutableDictionary) -> () {
        let keyChainQuery = self.getKeyChainQuery(service: service)
        SecItemDelete(keyChainQuery)
        keyChainQuery.setObject(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as! NSCopying)
        SecItemAdd(keyChainQuery, nil)
    }
    
    
    class func load(service: String) -> Any {
        var ret = NSKeyedUnarchiver()
        let keyChainQuery = self.getKeyChainQuery(service: service)
        keyChainQuery.setObject(kCFBooleanTrue, forKey: kSecReturnData as! NSCopying)
        keyChainQuery.setObject(kSecMatchLimitOne, forKey: kSecMatchLimit as! NSCopying)
        var keyData: AnyObject?
        if SecItemCopyMatching(keyChainQuery, &keyData) == errSecSuccess {
            do {
                ret = NSKeyedUnarchiver.unarchiveObject(with: keyData as! Data) as! NSKeyedUnarchiver
            }
        }
        return ret
    }
    
    /*
    
    具有独立开发iOS App的能力，并独立负责开发过易购付App(Swift)
    有丰富的解决崩溃、闪退、异常等问题的经验
    
    熟练使用Swift、Objective-C，能够使用Objective-C与Swift混编
    熟练使用Storyboard以及Xib进行界面布局，以及基本控件和自定义控件的使用
    熟练使用Block、闭包、代理、通知、单例等进行界面传值，了解应用间的跳转与传值
    熟练使用Alamofire、MJExtension、MJRefresh、SDWebImage、SnapKit、SVProgressHUD等第三方框架
    熟练使用OpenShare实现微信、支付宝、微博第三方的登录、分享、支付，以及极光推送的注册与使用
    熟练使用AMapLocation实现高德地图的定位、搜索、导航
    熟练使用iOS消息推送机制，了解iOS9与iOS10的推送适配
    熟练使用CoreData数据库，以及数据的持久化、安全性缓存
    熟练使用GitHub协作开发， 以及CocoaPods的安装与使用
    熟悉APP的打包、上架与版本更新流程，并懂得如何解决苹果官方审核拒绝
    能独立负责完成App的设计、开发，以及测试
 
 
     1、开发者账号以及App的注册
     2、微信、QQ、支付宝、高德地图等第三方账号申请，以及功能的实现
     3、使用Alamofire、MJRefresh、MJExtension等框架实现Json数据解析及使用
     4、使用UITableViewCell，以及自定义控件进行界面布局，实现界面展示
     5、使用微信、支付宝、QQ钱包实现App支付，以及分享
     6、使用高德地图实现定位、搜索以及导航
     7、实现消息通知推送，以及数据存储
     8、APP的打包、上架与版本更新，以及部分界面功能的设计与实现
     
     
     易购付是一款线下移动支付、收款工具。提供国内借记卡和信用卡充值、转账、支付、收款等服务，还可以在商城中购买多种特色食品
 
 
    */
    
    class func delete(service: String) -> () {
        let keyChainQuery = self.getKeyChainQuery(service: service)
        SecItemDelete(keyChainQuery)
    }
    
}
