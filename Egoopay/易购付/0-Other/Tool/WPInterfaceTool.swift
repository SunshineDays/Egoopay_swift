//
//  WPInterfaceTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPInterfaceTool: NSObject {
    
    /** UIAlertControllerStyleAlert */
    class func alertController(title: String?, confirmTitle: String, confirm: @escaping (_ alertAction: UIAlertAction)->(), cancel: @escaping (_ alertAction: UIAlertAction)->()) {
        let alertController: UIAlertController = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: confirmTitle, style: UIAlertActionStyle.default, handler: { (action) in
            confirm(action)
        }))
        alertController.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            cancel(action)
        }))
        (self.rootViewController() as AnyObject).present(alertController, animated: true, completion: nil)
    }
    
    /** UIAlertControllerStyleAlert */
    class func alertController(title: String?, rowOneTitle: String, rowTwoTitle: String, rowOne: @escaping (_ alertAction: UIAlertAction)->(), rowTwo: @escaping (_ alertAction: UIAlertAction)->()) {
        let alertController: UIAlertController = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        if rowOneTitle.count > 0 {
            alertController.addAction(UIAlertAction.init(title: rowOneTitle, style: rowOneTitle.contains("删除") || rowOneTitle.contains("解除") ? UIAlertActionStyle.destructive : UIAlertActionStyle.default, handler: { (action) in
                rowOne(action)
            }))
        }
        if rowTwoTitle.count > 0 {
            alertController.addAction(UIAlertAction.init(title: rowTwoTitle, style: rowTwoTitle.contains("删除") || rowTwoTitle.contains("解除") ? UIAlertActionStyle.destructive : UIAlertActionStyle.default, handler: { (action) in
                rowTwo(action)
            }))
        }
        alertController.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        (self.rootViewController() as AnyObject).present(alertController, animated: true, completion: nil)
    }
    
    /**  获取rootViewController */
    class func rootViewController() -> (AnyObject) {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if (rootViewController?.isKind(of: UINavigationController.self))! {
            rootViewController = (rootViewController as? UINavigationController)?.viewControllers.first
        }
        if (rootViewController?.isKind(of: UITabBarController.self))! {
            rootViewController = (rootViewController as? UITabBarController)?.selectedViewController
        }
        return rootViewController!
    }

    /**  返回到指定控制器 */
    class func popToViewController(controller: UIViewController) -> () {
        for ctr in ((self.rootViewController() as? UINavigationController)?.viewControllers)! {
            
            if ctr.isKind(of: controller.classForCoder) {
                (self.rootViewController() as? UINavigationController)?.popToViewController(ctr, animated: true)
            }
        }
    }
    
    /**
     * 返回到前面的控制器
     * popCout:返回的次数
     */
    class func popToViewController(navigationController: UINavigationController?, popCount: NSInteger) -> () {
        let viewControllers = navigationController?.viewControllers
        navigationController?.popToViewController(viewControllers![(viewControllers?.count)! - popCount - 1], animated: true)
    }
    
    /**
     * 返回到前面的控制器
     * popCout:返回的次数
     */
    class func popToViewController(popCount: NSInteger) {
        let navigationController: UINavigationController = WPInterfaceTool.rootViewController() as! UINavigationController
        let viewControllers = navigationController.viewControllers
        navigationController.popToViewController(viewControllers[viewControllers.count - popCount - 1], animated: true)
    }
    
    /**  支付结果界面 */
    class func showResultView(title: String, money: Float, payState: String) {
        let view = WPPaySuccessResultView()
        view.initInfor(title: title, money: money, payState: payState)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    
    /**  支付二维码界面 */
    class func showPayCodeView(result: AnyObject) {
        let model: WPPayCodeModel = WPPayCodeModel.mj_object(withKeyValues: result)
        let view = WPPayResultCodeView()
        view.initInfor(model: model)
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    /**  H5界面 */
    class func showWebViewController(url: String, title: String) {
        let vc = WPWebViewController()
        vc.webUrl_string = url
        vc.navigationItem.title = title
        WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
    }
    
    /**  打电话 */
    class func callToNum(numString: String) {
        let telNumber = "tel:" + numString
        let callWebView = UIWebView()
        callWebView.loadRequest(URLRequest.init(url: URL.init(string: telNumber)!))
        UIApplication.shared.keyWindow?.addSubview(callWebView)
    }
    
    /**  动态设置按钮颜色 */
    class func changeButtonColor(button: WPThemeButton, array: NSMutableArray) ->() {
        var isColor = true
        for i in 0 ..< array.count {
            if array[i] as! String == "" {
                isColor = false
            }
        }
        button.backgroundColor = isColor ? UIColor.themeColor() : UIColor.colorConvert(colorString: "#DDDDDD")
        button.titleLabel?.textColor = isColor ? UIColor.buttonTitleColor() : UIColor.colorConvert(colorString: "#BDBDBD")
        button.isUserInteractionEnabled = isColor
    }
    
    
    class func changeButtonColor(tableView: UITableView, row: Int, section: Int, array: NSMutableArray) -> () {
        var isColor = true
        for i in 0 ..< array.count {
            let obj = String(format: "%@", array[i] as! CVarArg)
            if obj == "" {
                isColor = false
            }
        }
        let indexpath = IndexPath.init(row: row, section: section)
        let cell: WPConfirmButtonCell = tableView.cellForRow(at: indexpath) as! WPConfirmButtonCell
        cell.confirm_button.setTitleColor(isColor ? UIColor.buttonTitleColor() : UIColor.colorConvert(colorString: "#BDBDBD"), for: UIControlState.normal)
        cell.confirm_button.backgroundColor = isColor ? UIColor.themeColor() : UIColor.colorConvert(colorString: "#DDDDDD")
        cell.confirm_button.isUserInteractionEnabled = isColor
    }
    
    class func adjustButtonColor(button: UIButton, array: NSMutableArray) -> () {
        var isColor = true
        for i in 0 ..< array.count {
            let obj = String(format: "%@", array[i] as! CVarArg)
            if obj == "" {
                isColor = false
            }
        }
        button.setTitleColor(isColor ? UIColor.buttonTitleColor() : UIColor.colorConvert(colorString: "#BDBDBD"), for: UIControlState.normal)
        button.backgroundColor = isColor ? UIColor.themeColor() : UIColor.colorConvert(colorString: "#DDDDDD")
        button.isUserInteractionEnabled = isColor
    }
    
    /**  选中某件商品 */
    class func eShopSelectedOne(button: UIButton, array: NSMutableArray, allButton: UIButton) {
        button.setImage(button.imageView?.image == #imageLiteral(resourceName: "icon_eShopShoppingCart_default") ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        
        let model: WPEShopProductModel = array[button.tag] as! WPEShopProductModel
        model.isSelected = button.imageView?.image == #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") ? 1 : 0
        
        let selectModelArray = NSMutableArray()
        let baseArray = NSMutableArray()
        
        for i in 0 ..< array.count {
            let models: WPEShopProductModel = array[i] as! WPEShopProductModel
            baseArray.add(1)
            selectModelArray.add(models.isSelected == 1 ? 1 : 0)
        }
        if baseArray == selectModelArray {
            allButton.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_selected"), for: .normal)
        }
        else {
            allButton.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        }
    }
    
    /**  全选商品 */
    class func eShopSelectedAll(array: NSMutableArray, allButon: UIButton, tableView: UITableView) {
        allButon.setImage(allButon.imageView?.image == #imageLiteral(resourceName: "icon_eShopShoppingCart_default") ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        for i in 0 ..< array.count {
            let model: WPEShopProductModel = array[i] as! WPEShopProductModel
            model.isSelected = allButon.imageView?.image == #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") ? 1 : 0
        }
        tableView.reloadData()
    }
    
}
