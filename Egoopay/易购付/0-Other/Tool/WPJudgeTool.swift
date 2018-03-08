//
//  WPJudgeTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import LocalAuthentication

class WPJudgeTool: NSObject {
    
    /**  验证手机号码 */
    class func validate(mobile: Any) -> Bool {
        //手机号以13,15,17,18开头，八个 \d 数字字符
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: mobile )
    }
    
    
    /**  验证固定电话 */
    class func validate(tel: String) -> Bool {
        //010,020,021,022,023,024,025,027,028,029,400
        let telRegex: String = "^((0(10|2[0-5789]|\\d{3}))|(400))\\d{7,8}$"
        let telTest = NSPredicate(format: "SELF MATCHES %@", telRegex)
        return telTest.evaluate(with:tel)
    }
    
    /** 验证邮箱 */
    class func validate(email: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
    /** 验证身份证号码 */
    class func validate(idCard: String) -> Bool {
        let idRegex: String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idTest.evaluate(with: idCard)
    }
    
    /**  验证银行卡类型 */
    class func validate(cardDic: NSDictionary) -> String {
        let plist_string: String = Bundle.main.path(forResource: "BankCardName", ofType: "plist")!
        let plist_dic: NSDictionary = NSDictionary(contentsOfFile: plist_string)!
        let cardName_string = plist_dic[cardDic["bank"] as! String] as! String
        return cardName_string
    }
    
    /**  是否是测试账号（用于App Store审核） */
    class func isText() -> Bool {
        return WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) == "18888888888" ? true : false
    }
    
    /**  是否通过实名认证 */
    class func isPassApprove() -> Bool {
        return WPUserDefaults.userDefaultsRead(key: WPUserDefaults_approvePassType) == "YES" ? true : false
    }
    
    /**  是否设置支付密码 */
    class func isSetPayPassword() -> Bool {
        return WPUserDefaults.userDefaultsRead(key: WPUserDefaults_payPasswordType) == "YES" ? true : false
    }
    
    /**  是否开启指纹登录 */
    class func isOpenTouchIDRegister() -> Bool {
        return WPUserDefaults.userDefaultsRead(key: WPUserDefaults_touchIDRegister) == "YES" ? true : false
    }
    
    /**  是否开启指纹支付 */
    class func isOpenTouchIDPay() -> Bool {
        return WPUserDefaults.userDefaultsRead(key: WPUserDefaults_touchIDPay) == "YES" ? true : false
    }
    
    /**  判断设备是否支持指纹识别 */
    class func isOpenTouchID() -> Bool {
        let context = LAContext()
        var error: NSError? = nil
        let isTouchID = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return isTouchID
    }

    /**  是否显示商城 */
    class func isEShop() -> Bool {
        return WPUserDefaults.userDefaultsRead(key: WPUserDefaults_isEShop) == "YES" ? true : false
    }
    
    
    /** 验证输入是否是空格 */
    class func validate(replacementStrings: String) -> Bool {
        if replacementStrings == " " {
            return false
        }
        else {
            return true
        }
    }
    
    class func validate(textField: UITextField, range: NSRange, replacementString: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text!, range: range, replacementString: replacementString)
    }
    
    
    
    
}
