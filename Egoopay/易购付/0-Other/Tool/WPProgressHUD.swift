//
//  WPProgressHUD.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPProgressHUD: NSObject {
    
    class  func initInfor() -> () {
        SVProgressHUD.setCornerRadius(5)
        SVProgressHUD.setBackgroundColor(UIColor.colorConvert(colorString: "#323233", alpha: 1))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }
    
    /**  网络正在请求(无提示) */
    class func showProgressIsLoading() -> () {
        initInfor()
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 80, height: 75))
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: nil)
    }
    
    /**  网络正在请求(有提示) */
    class func showProgress(status: String?) -> () { 
        initInfor()
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 120, height: 110))
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: status)
    }
    
    /**  提示信息 */
    class func showInfor(status: String) -> () {
        initInfor()
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 100, height: 30))
        SVProgressHUD.setInfoImage(nil)
        SVProgressHUD.dismiss(withDelay: Double(status.count) * 0.02 + 0.8)
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    /**  成功提示 */
    class func showSuccess(status: String) -> () {
        initInfor()
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 80, height: 75))
        SVProgressHUD.dismiss(withDelay: 0.6)
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    /**  失败提示 */
    class func showError(status: String) -> () {
        initInfor()
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 80, height: 75))
        SVProgressHUD.dismiss(withDelay: Double(status.count) * 0.02 + 0.8)
        SVProgressHUD.showError(withStatus: status)
    }
    
    /**  提示消失 */
    class func dismiss() -> () {
        initInfor()
        SVProgressHUD.dismiss()
    }
    
}




