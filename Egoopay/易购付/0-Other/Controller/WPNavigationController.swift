//
//  WPNavigationController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !WPJudgeTool.isEShop() {
            self.navigationBar.setBackgroundImage(UIImage.imageFromColor(color: UIColor.themeColor()), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage()
            let dictM: NSMutableDictionary = NSMutableDictionary()
            dictM[NSAttributedStringKey.foregroundColor] = UIColor.white
            dictM[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight(rawValue: 0.5))
            self.navigationBar.titleTextAttributes = dictM as? [NSAttributedStringKey : Any]
            self.navigationBar.tintColor = UIColor.white
        }
        else {
            let dictM: NSMutableDictionary = NSMutableDictionary()
            dictM[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight(rawValue: 0.5))
            self.navigationBar.titleTextAttributes = dictM as? [NSAttributedStringKey : Any]
            self.navigationBar.tintColor = UIColor.black
        }
        self.navigationBar.isTranslucent = false

    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            // 非根控制器隐藏tabBar
            viewController.tabBarController?.tabBar.isHidden = true
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

