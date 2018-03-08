//
//  WPAppRegister.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import AdSupport

class WPAppRegister: NSObject {

    class func registerShareApp() {
        OpenShare.connectQQ(withAppId: kQQ_appID)
        OpenShare.connectWeixin(withAppId: kWeChat_appID)
    }
    
    class func registerAMap() {
        AMapSearchServices.shared().apiKey = kAMap_apiKey
        MAMapServices.shared().apiKey = kAMap_apiKey
        AMapLocationServices.shared().apiKey = kAMap_apiKey
    }
    
    class func registerJpush(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let advertisingID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.register(forRemoteNotificationTypes: JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue | JPAuthorizationOptions.alert.rawValue, categories: nil)
        
        JPUSHService.crashLogON()
        JPUSHService.setup(withOption: launchOptions, appKey: kJPush_appKey, channel: "AppStore", apsForProduction: false, advertisingIdentifier: advertisingID)
    }
    
    class func register3DTouch(application: UIApplication) {
        let codeIcon = UIApplicationShortcutIcon.init(templateImageName: "share_appCode")
        let codeItem = UIApplicationShortcutItem.init(type: "TWO", localizedTitle: "我的收款码", localizedSubtitle: nil, icon: codeIcon, userInfo: nil)
        application.shortcutItems = [codeItem]
    }
}
