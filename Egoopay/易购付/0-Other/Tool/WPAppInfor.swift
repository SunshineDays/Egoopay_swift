//
//  WPAppInfor.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let kAppDefaultsVersionKey = "CFBundleShortVersionString"

let kAppDefaultsBuildKey = "CFBundleVersion"

class WPAppInfor: NSObject {
    
    /**  获取APP版本号 */
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kAppDefaultsVersionKey) as! String
    }
    
    /**  获取Build id */
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kAppDefaultsBuildKey) as! String
    }
    
    /**  获取UUID */
    class func iOSDeviceID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    /**  获取系统版本号 */
    class func iOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
}
