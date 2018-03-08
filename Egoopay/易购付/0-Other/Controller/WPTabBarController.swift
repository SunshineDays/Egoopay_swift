//
//  WPTabBarController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var currentIndex: NSInteger = NSInteger()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
        if WPJudgeTool.isEShop() {
            UIApplication.shared.statusBarStyle = .default
            initEShopTabBarViewControllers()
        }
        else {
            UIApplication.shared.statusBarStyle = .lightContent
            initTabBarViewControllers()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTabBarViewControllers() {
        let titleArray: NSArray = ["首页", "消息", "加盟", "我"]
        let imageArray: NSArray = ["icon_tab_souye", "icon_tab_xiaoxi", "icon_tab_jiameng", "icon_tab_wo"]
        let controllersArray: NSArray = [WPJudgeTool.isText() ? WPTestHomePageController() : WPHomePageController(), WPBillMessageController(), WPAgencyController(), WPPersonalController()]
        
        for i in 0 ..< controllersArray.count {
            
            let defaultImage: UIImage = UIImage(named: (imageArray[i] as! String + "_n"))!
            let selectedImage: UIImage = UIImage(named: (imageArray[i] as! String + "_s"))!            
            
            
            self.setupOneChildVc(childVc: WPNavigationController.init(rootViewController: controllersArray[i] as! UIViewController), title: titleArray[i] as! String, titleColor: UIColor.themeColor(), defaultImage: defaultImage, selectedImage: selectedImage)
        }
    }
    
    func initEShopTabBarViewControllers() {
        let titleArray: NSArray = ["首页", "购物车", "我"]
        let imageArray: NSArray = ["icon_eShopHomePage", "icon_eShopCart", "icon_eShopPersonal"]
        let controllersArray: NSArray = [WPEShopHomePageController(), WPEShopShoppingCartController(), WPEShopPersonalController()]
        
        for i in 0 ..< controllersArray.count {
            
            let defaultImage: UIImage = UIImage(named: (imageArray[i] as! String + "_default"))!
            let selectedImage: UIImage = UIImage(named: (imageArray[i] as! String + "_selected"))!
            
            
            self.setupOneChildVc(childVc: WPNavigationController.init(rootViewController: controllersArray[i] as! UIViewController), title: titleArray[i] as! String, titleColor: UIColor.colorConvert(colorString: "32A77A"), defaultImage: defaultImage, selectedImage: selectedImage)
        }
    }
    
    
    func setupOneChildVc(childVc: UIViewController, title: String, titleColor: UIColor, defaultImage: UIImage, selectedImage: UIImage) {
        childVc.tabBarItem.title = title
        self.tabBar.tintColor = titleColor
        childVc.tabBarItem.image = defaultImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childVc.tabBarItem.selectedImage = selectedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.addChildViewController(childVc)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "消息" {
            NotificationCenter.default.post(name: WPNotificationSelectedMessageItem, object: nil)
        }
//        if item.title == "购物车" {
//            NotificationCenter.default.post(name: WPNotificationSelectedCartItem, object: nil)
//        }
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController.isKind(of: WPNavigationController.classForCoder()) {
//            let navi: WPNavigationController = (viewController as? WPNavigationController)!
//            let _viewController = navi.viewControllers.first
//
//            if (_viewController?.isKind(of: WPHomePageController.classForCoder()))! {
//                WPDrawerManager.manager.beginDragResponse()
//            }
//            else {
//                WPDrawerManager.manager.cancelDragResponse()
//            }
//        }
//    }
    
    
}

