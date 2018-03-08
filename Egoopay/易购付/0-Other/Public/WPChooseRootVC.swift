//
//  WPChooseRootVC.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/5.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPChooseRootVC: NSObject {
    
    class func chooseRootViewController () -> UIViewController {
        
//        let oldVersion: String = UserDefaults.standard.object(forKey: kAppDefaultsVersionKey) as? String ?? ""
//
//        let newVersion: String = WPAppInfor.appVersion()
        
        if WPUserDefaults.userDefaultsRead(key: WPUserDefault_firstInstall) == nil {
            WPUserDefaults.userDefaultsSave(key: WPUserDefault_firstInstall, value: "NO")
            return WPNavigationController(rootViewController: WPNewFeatureController())
        }
        else if WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) == nil {
            return WPNavigationController(rootViewController: WPRegisterViewController())
        }
        else {
            return WPTabBarController()
        }
        
        
//        if oldVersion == newVersion {
//            if WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) == nil {
//                return WPNavigationController(rootViewController: WPRegisterViewController())
//            }
//            else {
//                return WPTabBarController()
//            }
//        }
//        else {
//            UserDefaults.standard.setValue(newVersion, forKey: kAppDefaultsVersionKey)
//            UserDefaults.standard.synchronize()
//
//            if WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) == nil {
//                return WPNavigationController(rootViewController: WPRegisterViewController())
//            }
//            else {
//                return WPTabBarController()
//            }
//        }
        
    }
}
