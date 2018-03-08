//
//  AppDelegate.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/5.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import CoreData
import SnapKit
//import AdSupport
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: nil)

        UIApplication.shared.statusBarStyle = .lightContent
        
        self.window?.rootViewController = WPChooseRootVC.chooseRootViewController()
                
        WPAppRegister.registerAMap()
        WPAppRegister.registerShareApp()
        WPAppRegister.registerJpush(launchOptions: launchOptions)
        WPAppRegister.register3DTouch(application: application)

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        //键盘不需要标题
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        //点击背景隐藏键盘
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        return true
    }
    
    /**  注册极光推送 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    /**  前台 */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.alert.rawValue | UNNotificationPresentationOptions.badge.rawValue))
    }
    
    /**  后台 */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        WPJpushSeriveTool.jpushService(userInfor: response.notification.request.content.userInfo as NSDictionary)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    /**  app从前台退出 */
    func applicationDidEnterBackground(_ application: UIApplication) {
        JPUSHService.setBadge(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "TWO" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                if WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) != nil {
                    WPInterfaceTool.rootViewController().pushViewController(WPMyGatheringCodeController(), animated: true)
                }
            })
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Egoopay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

