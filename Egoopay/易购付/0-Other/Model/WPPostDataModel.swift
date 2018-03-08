//
//  WPPostDataModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/11.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPostDataModel: NSObject {

    /**  登录 */
    class func postData(phone : String, password : String, success : @escaping (_ result : AnyObject) -> ()) {
        let parameter = ["phone" : phone,
                         "password" : password,
                         "mobileID" : WPAppInfor.iOSDeviceID(),
                         "deviceOem" : "iPhone",
                         "deviceOS" : "iOS" + WPAppInfor.iOSVersion(),
                         "appVersion" : WPAppInfor.appVersion()]
        
        WPDataTool.POSTRequest(url: WPRegisterURL, parameters: parameter, success: { (result) in
            success(result)
        }) { (error) in
            
        }
    }
    
    
    /**  修改密码 */
    class func postData(phone : String, passType : String, authCode : String, newPassword : String, success : @escaping (_ result : AnyObject) -> ()) {
        let parameter = ["phone" : phone, "passType" : passType, "var" : authCode, "newPassword" : newPassword]
        WPDataTool.POSTRequest(url: WPChangePasswordURL, parameters: parameter, success: { (result) in
            success(result)
        }) { (error) in
            
        }
    }
    
}
